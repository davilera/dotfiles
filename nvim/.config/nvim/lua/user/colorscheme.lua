local colorscheme = 'tokyonight-night'

-- Customize tokyonight if available
local tokyonight_ok, tokyonight = pcall(require, 'tokyonight')
if tokyonight_ok then
	tokyonight.setup({
		style = 'night',
		on_colors = function(colors)
			colors.fg = '#dde3ff'
		end,
	})
end

-- Use tokyonight if possible
local colorscheme_ok, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)
if not colorscheme_ok then
	vim.cmd('colorscheme default')
	vim.notify('Unable to load colorscheme “' .. colorscheme .. '.”')
	return
end
