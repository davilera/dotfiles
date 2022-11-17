local servers = {
	'cssls', -- CSS
	'elmls', -- Elm
	'emmet_ls', -- HTML autocompletes
	'intelephense', -- PHP
	'jsonls', -- JSON magic
	'sumneko_lua', -- Neovim config files
	'tsserver', -- TypeScript
}

local settings = {
	ui = {
		border = 'none',
		icons = {
			package_installed = '◍',
			package_pending = '◍',
			package_uninstalled = '◍',
		},
		log_level = vim.log.levels.INFO,
		max_concurrent_installers = 4,
	},
}

require('mason').setup(settings)
require('mason-lspconfig').setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require('user.lsp.handlers').on_attach,
		capabilities = require('user.lsp.handlers').capabilities,
	}

	server = vim.split(server, '@')[1]

	local has_server_opts, server_opts = pcall(require, 'user.lsp.settings.' .. server)
	if has_server_opts then
		opts = vim.tbl_deep_extend('force', server_opts, opts)
	end

	lspconfig[server].setup(opts)
end
