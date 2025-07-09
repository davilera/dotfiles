return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		opts = {
			transparent_background = true,
			styles = {
				conditionals = { 'bold' },
				loops = { 'bold' },
				keywords = { 'bold' },
			},
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-mocha",
		},
	},
}
