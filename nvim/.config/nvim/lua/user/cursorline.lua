local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cursor_line_group = augroup('cursor_line_group', {})

autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter', 'BufEnter' }, {
	group = cursor_line_group,
	pattern = '*',
	callback = function()
		vim.cmd('setlocal cursorline')
	end,
})

autocmd({ 'VimLeave', 'WinLeave', 'BufWinLeave', 'BufLeave' }, {
	group = cursor_line_group,
	pattern = '*',
	callback = function()
		vim.cmd('setlocal nocursorline')
	end,
})
