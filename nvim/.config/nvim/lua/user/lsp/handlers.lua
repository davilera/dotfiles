local M = {}

local cmp_ok, cmp_nvim_lsp = pcall( require, 'cmp_nvim_lsp' )
if not cmp_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities( M.capabilities )

M.setup = function()
	local signs = {
		{ name = 'DiagnosticSignError', text = '' },
		{ name = 'DiagnosticSignWarn',  text = '' },
		{ name = 'DiagnosticSignHint',  text = '' },
		{ name = 'DiagnosticSignInfo',  text = '' },
	}

	for _, sign in ipairs( signs ) do
		vim.fn.sign_define( sign.name, { texthl = sign.name, text = sign.text, numhl = '' } )
	end

	local config = {
		virtual_text = false,
		signs = { active = signs },
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style     = 'minimal',
			border    = 'rounded',
			source    = 'always',
			header    = '',
			prefix    = '',
		},
	}

	vim.diagnostic.config( config )

	vim.lsp.handlers[ 'textDocument/hover' ] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = 'rounded' }
	)

	vim.lsp.handlers[ 'textDocument/signatureHelp' ] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = 'rounded' }
	)
end

local function keymap( bufnr, shortcut, command )
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap( bufnr, 'n', shortcut, '<cmd>' .. command .. '<CR>', opts )
end

local function lsp_keymaps( bufnr )
	keymap( bufnr, '<Leader>i', 'lua vim.lsp.buf.hover()' )         -- [I]nformation
	keymap( bufnr, '<Leader>g', 'lua vim.lsp.buf.declaration()' )   -- [G]o to declaration
	keymap( bufnr, '<Leader>r', 'lua vim.lsp.buf.hover()' )         -- [R]eferences
	keymap( bufnr, '<Leader>j', 'lua vim.lsp.buf.definition()' )    -- [J]ump to file

	keymap( bufnr, '<Leader>h', 'lua vim.diagnostic.open_float()' ) -- [H]elp with current error
	keymap( bufnr, '<Leader>n', 'lua vim.diagnostic.goto_next()' )  -- (j) Next error
	keymap( bufnr, '<Leader>p', 'lua vim.diagnostic.goto_prev()' )  -- (k) Prev error

	keymap( bufnr, '<Leader>f', 'lua vim.lsp.buf.formatting_sync()' )  -- [F]ormat code
end

M.on_attach = function( client, bufnr )
	if client.name == 'sumneko_lua' then
		client.server_capabilities.documentFormattingProvider = false
	end

	lsp_keymaps( bufnr )

	local ok, illuminate = pcall( require, 'illuminate' )
	if ok then
		illuminate.on_attach( client )
	end
end

return M
