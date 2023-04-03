local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
	return
end

local completion = null_ls.builtins.completion
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

null_ls.setup({
	sources = {
		completion.spell,
		diagnostics.eslint_d,
		formatting.elm_format,
		formatting.eslint_d,
		formatting.phpcbf.with({
			command = './vendor/bin/phpcbf',
			args = { '-q', '--stdin-path=$FILENAME', '--standard=phpcs.ruleset.xml', '-' },
		}),
		formatting.prettier,
		formatting.stylua,
	},
})
