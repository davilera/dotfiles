local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
	return
end

local formatting = null_ls.builtins.formatting
local completion = null_ls.builtins.completion

null_ls.setup({
	sources = {
		completion.spell,
		formatting.phpcbf.with({
			command = './vendor/bin/phpcbf',
			args = { '-q', '--stdin-path=$FILENAME', '--standard=phpcs.ruleset.xml', '-' },
		}),
		formatting.prettier,
		formatting.stylua,
	},
})
