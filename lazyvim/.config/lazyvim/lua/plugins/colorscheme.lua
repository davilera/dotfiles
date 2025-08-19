return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		priority = 1000,
		opts = {
			transparent_background = true,
			term_colors = true,
			integrations = {
				bufferline = true,
			},
			styles = {
				conditionals = { 'bold' },
				loops = { 'bold' },
				keywords = { 'bold' },
			},
		},
	},
	{
		"akinsho/bufferline.nvim",
		opts = {
			highlights = require("catppuccin.groups.integrations.bufferline").get({})
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-mocha",
		},
	},
}
