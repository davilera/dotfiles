vim.cmd([[
	augroup _lsp
		autocmd!
		autocmd BufWritePre * lua vim.lsp.buf.format({ timeout_ms = 5000 })
	augroup end
]])
