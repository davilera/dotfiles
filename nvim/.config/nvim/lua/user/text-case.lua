local status_ok, textcase = pcall(require, 'textcase')
if not status_ok then
	return
end

textcase.setup({})
