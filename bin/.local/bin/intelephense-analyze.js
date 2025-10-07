#!/usr/bin/env node
/**
 * Minimal LSP client for Intelephense (PHP) over stdio.
 * Usage: node intelephense-analyze.js path/to/file1.php path/to/file2.php ...
 *
 * It:
 *  - starts `intelephense --stdio`
 *  - sends initialize/initialized
 *  - didOpen for each file (with full text)
 *  - prints textDocument/publishDiagnostics as they arrive
 *  - exits after receiving at least one diagnostics batch per requested file
 */

const { spawn } = require("child_process");
const { readFileSync, existsSync } = require("fs");
const { pathToFileURL } = require("url");
const path = require("path");

if (process.argv.length < 3) {
  console.error(
    "Usage: node intelephense-analyze.js <file.php> [more.php ...]",
  );
  process.exit(2);
}

// Validate files and build URI map
const files = process.argv.slice(2).map((p) => path.resolve(p));
for (const f of files) {
  if (!existsSync(f)) {
    console.error(`File not found: ${f}`);
    process.exit(2);
  }
}
const fileUris = files.map((f) => pathToFileURL(f).href);
let totalErrors = 0;

// Spawn intelephense
const server = spawn("intelephense", ["--stdio"], {
  stdio: ["pipe", "pipe", "pipe"],
});

server.on("error", (err) => {
  console.error(
    "Failed to start intelephense. Is it installed (`npm i -g intelephense`)?",
  );
  console.error(err.message);
  process.exit(1);
});

// --- JSON-RPC / LSP framing helpers ---
let idCounter = 1;
function nextId() {
  return idCounter++;
}

function writeMessage(obj) {
  const json = JSON.stringify(obj);
  const msg = `Content-Length: ${Buffer.byteLength(
    json,
    "utf8",
  )}\r\n\r\n${json}`;
  server.stdin.write(msg);
}

let buffer = Buffer.alloc(0);
server.stdout.on("data", (chunk) => {
  buffer = Buffer.concat([buffer, chunk]);
  // Parse one or more LSP frames
  while (true) {
    const headerEnd = buffer.indexOf("\r\n\r\n");
    if (headerEnd === -1) break;

    const header = buffer.slice(0, headerEnd).toString("utf8");
    const match = /Content-Length:\s*(\d+)/i.exec(header);
    if (!match) {
      // malformed; drop the buffer to avoid infinite loop
      buffer = Buffer.alloc(0);
      break;
    }
    const length = parseInt(match[1], 10);
    const total = headerEnd + 4 + length;
    if (buffer.length < total) break;

    const body = buffer.slice(headerEnd + 4, total).toString("utf8");
    buffer = buffer.slice(total);

    try {
      const msg = JSON.parse(body);
      handleMessage(msg);
    } catch (e) {
      console.error("Failed to parse LSP message:", e);
    }
  }
});

// Collect diagnostics
const pending = new Set(fileUris);
const receivedOnce = new Set(); // URIs that have received at least one diagnostics publish
let initialized = false;

// Logging of stderr from the server (useful if license warnings etc.)
server.stderr.on("data", (d) => {
  process.stderr.write(String(d));
});

// Handle server messages
function handleMessage(msg) {
  // Responses (result/error) and notifications (method)
  if (msg.method === "window/logMessage") {
    // Optional: uncomment to see server logs
    // console.error(`[server] ${msg.params.type}: ${msg.params.message}`);
    return;
  }

  if (msg.method === "telemetry/event") {
    // ignore
    return;
  }

  if (msg.method === "textDocument/publishDiagnostics") {
    const { uri, diagnostics } = msg.params;
    printDiagnostics(uri, diagnostics);
    totalErrors += diagnostics.length;
    receivedOnce.add(uri);

    // Exit once we've seen at least one diagnostics batch for each file
    if (fileUris.every((u) => receivedOnce.has(u))) {
      shutdownAndExit();
    }
    return;
  }

  // After initialize result, send initialized + didOpen for each file
  if (msg.id && msg.result && pending.has("__await_init__")) {
    pending.delete("__await_init__");
    sendInitializedAndOpenFiles();
    return;
  }
}

// Pretty-print diagnostics
function printDiagnostics(uri, diags) {
  const filePath = path.relative(
    process.cwd(),
    decodeURIComponent(new URL(uri).pathname),
  );
  if (!Array.isArray(diags)) return;

  // Header per file publish
  if (diags.length === 0) {
    return;
  }

  for (const d of diags) {
    const start = d.range?.start ?? { line: 0, character: 0 };
    const sevMap = { 1: "Error", 2: "Warning", 3: "Info", 4: "Hint" };
    const sev = sevMap[d.severity] || "Unknown";
    const code = (typeof d.code === "object" ? d.code?.value : d.code) || "";
    const msg = d.message?.replace(/\s+/g, " ").trim();
    console.log(
      `${filePath}:${start.line + 1} ${
        code ? ` [${code}]` : ""
      } — ${sev}: ${msg}`,
    );
  }
}

// Graceful shutdown
let didShutdown = false;
function shutdownAndExit() {
  if (didShutdown) return;
  didShutdown = true;

  console.log(
    totalErrors
      ? `\n[ERROR] Found ${totalErrors} error${totalErrors > 1 ? "s" : ""}`
      : "\n[OK] No errors",
  );

  // Send shutdown request then exit notification
  const shutdownId = nextId();
  writeMessage({
    jsonrpc: "2.0",
    id: shutdownId,
    method: "shutdown",
    params: null,
  });

  // Give the server a brief moment, then send exit
  setTimeout(() => {
    writeMessage({ jsonrpc: "2.0", method: "exit" });
    server.stdin.end();
    // Ensure we actually terminate if the server keeps running
    setTimeout(() => process.exit(0), 250);
  }, 150);
}

// Kick off: initialize
(function init() {
  const rootUri = pathToFileURL(process.cwd()).href;
  const initializeParams = {
    processId: process.pid,
    rootUri,
    capabilities: {
      textDocument: {
        publishDiagnostics: {},
        synchronization: {
          didSave: true,
          willSave: false,
          willSaveWaitUntil: false,
        },
      },
      workspace: { configuration: true },
    },
    workspaceFolders: [{ uri: rootUri, name: path.basename(process.cwd()) }],
    initializationOptions: {
      // You can set intelephense settings here if desired, e.g.:
      // licenceKey: "XXXX-XXXX-XXXX-XXXX", // if you have a premium key
      // environment: {}, files: {}, diagnostics: {}, etc.
    },
  };

  const id = nextId();
  pending.add("__await_init__");
  writeMessage({
    jsonrpc: "2.0",
    id,
    method: "initialize",
    params: initializeParams,
  });
})();

function sendInitializedAndOpenFiles() {
  if (initialized) return;
  initialized = true;

  // Required by LSP after "initialize"
  writeMessage({ jsonrpc: "2.0", method: "initialized", params: {} });

  // (Optional) let server know about settings; empty default here
  writeMessage({
    jsonrpc: "2.0",
    method: "workspace/didChangeConfiguration",
    params: { settings: {} },
  });

  // Send didOpen for each file with full text — prompts analysis & diagnostics
  for (const filePath of files) {
    const uri = pathToFileURL(filePath).href;
    const text = readFileSync(filePath, "utf8");
    writeMessage({
      jsonrpc: "2.0",
      method: "textDocument/didOpen",
      params: {
        textDocument: {
          uri,
          languageId: "php",
          version: 1,
          text,
        },
      },
    });
  }

  // Safety net: if some file never gets a diagnostics publish, exit after timeout
  setTimeout(() => {
    if (!fileUris.every((u) => receivedOnce.has(u))) {
      console.error(
        "\nTimed out waiting for diagnostics from all files. Shutting down.",
      );
      shutdownAndExit();
    }
  }, 8000);
}

// Clean up on SIGINT
process.on("SIGINT", () => shutdownAndExit());
