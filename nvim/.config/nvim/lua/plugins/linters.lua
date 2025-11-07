return {
  "mfussenegger/nvim-lint",
  opts = {
    linters = {
      phpcs = {
        cmd = vim.env.HOME .. "/.config/composer/vendor/bin/phpcs",
      },
      ["wp-scripts-css"] = {
        cmd = vim.env.NVM_BIN .. "/wp-scripts",
        args = { "lint-css", "--format", "compact" },
        ignore_exitcode = true,
        parser = require("lint.parser").from_pattern(
          "([^:]+): line (%d+), col (%d+), (%w+) %-%s+(.*)",
          { "file", "lnum", "col", "severity", "message" },
          {
            Error = vim.diagnostic.severity.ERROR,
            Warning = vim.diagnostic.severity.WARN,
          }
        ),
      },
      ["wp-scripts-js"] = {
        cmd = vim.env.NVM_BIN .. "/wp-scripts",
        args = { "lint-js", "--format", "compact" },
        ignore_exitcode = true,
        parser = require("lint.parser").from_pattern(
          "([^:]+): line (%d+), col (%d+), (%w+) %-%s+(.*)",
          { "file", "lnum", "col", "severity", "message" },
          {
            Error = vim.diagnostic.severity.ERROR,
            Warning = vim.diagnostic.severity.WARN,
          }
        ),
      },
    },
    linters_by_ft = {
      css = { "stylelint", "wp-scripts-css" },
      scss = { "stylelint", "wp-scripts-css" },
      javascript = { "wp-scripts-js" },
      typescript = { "wp-scripts-js" },
      javascriptreact = { "wp-scripts-js" },
      typescriptreact = { "wp-scripts-js" },
      php = { "phpstan", "phpcs" },
    },
  },
}
