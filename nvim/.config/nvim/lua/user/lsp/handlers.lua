local M = {}

local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
	local signs = {
		{ name = 'DiagnosticSignError', text = '' },
		{ name = 'DiagnosticSignWarn', text = '' },
		{ name = 'DiagnosticSignHint', text = '' },
		{ name = 'DiagnosticSignInfo', text = '' },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
	end

	local config = {
		virtual_text = false,
		signs = { active = signs },
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = 'minimal',
			border = 'rounded',
			source = 'always',
			header = '',
			prefix = '',
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })

	vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
end

local function keymap(bufnr, shortcut, command)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, 'n', shortcut, '<cmd>' .. command .. '<CR>', opts)
end

local function lsp_keymaps(bufnr)
	keymap(bufnr, '<leader>la', 'lua vim.lsp.buf.code_action()') -- Code action
	keymap(bufnr, '<leader>ld', 'Telescope diagnostics bufnr=0') -- Document diagnostics
	keymap(bufnr, '<leader>lf', 'lua vim.lsp.buf.format({ async = true })') -- Format
	keymap(bufnr, '<leader>li', 'LspInfo') -- LSP Info
	keymap(bufnr, '<leader>lI', 'LspInstallInfo') -- LSP Installer Info
	keymap(bufnr, '<leader>lj', 'lua vim.diagnostic.goto_next()') -- Next diagnostic
	keymap(bufnr, '<leader>lk', 'lua vim.diagnostic.goto_prev()') -- Prev diagnostic
	keymap(bufnr, '<leader>lr', 'lua vim.lsp.buf.rename()') -- Rename
end

M.on_attach = function(client, bufnr)
	local ignored_formatters = { 'sumneko_lua', 'tsserver', 'intelephense' }
	for _, formatter in ipairs(ignored_formatters) do
		if formatter == client.name then
			client.server_capabilities.documentFormattingProvider = false
		end
	end

	lsp_keymaps(bufnr)

	local ok, illuminate = pcall(require, 'illuminate')
	if ok then
		illuminate.on_attach(client)
	end
end

return M
