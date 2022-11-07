local ok, highlighter = pcall( require, 'nvim-highlight-colors' )
if not ok then
	return
end

highlighter.turnOn()
