local status_ok, tabset = pcall(require, 'tabset')
if not status_ok then
	return
end

tabset.setup({
	defaults = {
		tabwidth = 2,
		expandtab = false,
	},
	languages = {
		elm = {
			tabwidth = 4,
			expandtab = true,
		},
		haskell = {
			tabwidth = 4,
			expandtab = true,
		},
		markdown = {
			tabwidth = 2,
			expandtab = true,
		},
		yaml = {
			tabwidth = 4,
			expandtab = true,
		},
	},
})
