local options = {
	backupdir = '/tmp', -- location of swap files
	cmdheight = 2, -- more space in neovim’s command line for displaying messages
	completeopt = { 'menuone', 'noselect' }, -- show matching options and force the user to select one
	cursorline = true, -- highlight current line
	cursorlineopt = 'both', -- highlight current line
	encoding = 'utf-8', -- fix encoding
	hidden = true, -- prefer hiding over unloading buffers
	hlsearch = true, -- highlight search
	mouse = '', -- disable mouse integration
	number = true, -- show line numbers (current line only when combined with relative numbers)
	path = '.,**/*', -- search relative to current file + directory
	pumheight = 10, -- popup menu height
	relativenumber = true, -- show relative numbers
	scrolloff = 8, -- keep some context around current line
	sidescrolloff = 8, -- keep some context around current line
	shiftwidth = 2, -- indentation defaults (<< / >> / == / auto)
	smartindent = true, -- try to guess current indentation level
	splitbelow = true, -- prefer new horizontal split below
	splitright = true, -- prefer new vertical split to the right
	tabstop = 2, -- tab characters take two spaces only
	updatetime = 300, -- faster autocomplete
	undolevels = 100, -- number of undo levels
	wrap = false, -- wrap long lines
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
