local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
	return
end

local formatting = null_ls.builtins.formatting
local completion = null_ls.builtins.completion

null_ls.setup({
	sources = {
		formatting.prettier,
		formatting.stylua,
		completion.spell,
	},
})
