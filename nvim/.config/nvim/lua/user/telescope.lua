local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
	return
end

telescope.setup({
	prompt_prefix = ' ',
	selection_caret = ' ',
	path_display = { 'smart' },
})
