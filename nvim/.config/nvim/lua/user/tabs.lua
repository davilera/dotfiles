local status_ok, tabset = pcall(require, 'tabset')
if not status_ok then
  vim.notify('oops')
	return
end

vim.notify('gogogo')
tabset.setup({
	defaults = {
		tabwidth = 2,
		expandtab = false,
	},
  languages = {
    haskell = {
      tabwidth = 4,
      expandtab = true,
    },
    markdown = {
      tabwidth = 2,
      expandtab = true,
    },
  },
})
