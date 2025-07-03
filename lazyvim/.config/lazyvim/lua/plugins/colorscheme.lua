return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
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
