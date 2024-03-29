local status_ok, which_key = pcall(require, 'which-key')
if not status_ok then
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
		separator = '➜', -- symbol used between a key and its label
		group = '+', -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = '<c-d>', -- binding to scroll down inside the popup
		scroll_up = '<c-u>', -- binding to scroll up inside the popup
	},
	window = {
		border = 'rounded', -- none, single, double, shadow
		position = 'bottom', -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = 'left', -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { '<silent>', '<cmd>', '<cr>', 'call', 'lua', '^:', '^ ' }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = 'auto', -- automatically setup triggers
	-- triggers = {"<Leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { 'j', 'k' },
		v = { 'j', 'k' },
	},
}

local opts = {
	mode = 'n', -- NORMAL mode
	prefix = '<Leader>',
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local normal_mappings = {
	['e'] = { '<cmd>NvimTreeSmartToggle<cr>', 'Explorer' },
	['w'] = { '<cmd>w!<cr>', 'Save' },
	['q'] = { '<cmd>q<cr>', 'Quit' },
	['f'] = {
		"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
		'Find files',
	},
	['t'] = { '<cmd>Telescope live_grep theme=ivy <cr>', 'Grep files' },

	c = {
		name = 'Case',
		['.'] = { "<cmd>lua require('textcase').current_word('to_dot_case')<cr>", 'Dot case' },
		['-'] = { "<cmd>lua require('textcase').current_word('to_dash_case')<cr>", 'Dash case' },
		['_'] = { "<cmd>lua require('textcase').current_word('to_snake_case')<cr>", 'Snake case' },
		c = { "<cmd>lua require('textcase').current_word('to_camel_case')<cr>", 'Camel case' },
		k = { "<cmd>lua require('textcase').current_word('to_constant_case')<cr>", 'Constant case' },
		l = { "<cmd>lua require('textcase').current_word('to_lower_case')<cr>", 'Lower case' },
		p = { "<cmd>lua require('textcase').current_word('to_pascal_case')<cr>", 'Pascal case' },
		u = { "<cmd>lua require('textcase').current_word('to_upper_case')<cr>", 'Upper case' },
	},

	p = {
		name = 'Packer',
		c = { '<cmd>PackerCompile<cr>', 'Compile' },
		i = { '<cmd>PackerInstall<cr>', 'Install' },
		s = { '<cmd>PackerSync<cr>', 'Sync' },
		S = { '<cmd>PackerStatus<cr>', 'Status' },
		u = { '<cmd>PackerUpdate<cr>', 'Update' },
	},

	g = {
		name = 'Git',
		j = { "<cmd>lua require('gitsigns').next_hunk()<cr>", 'Next hunk' },
		k = { "<cmd>lua require('gitsigns').prev_hunk()<cr>", 'Prev hunk' },
		p = { "<cmd>lua require('gitsigns').preview_hunk()<cr>", 'Preview hunk' },
		l = { "<cmd>lua require('gitsigns').blame_line()<cr>", 'Blame' },
		r = { "<cmd>lua require('gitsigns').reset_hunk()<cr>", 'Reset hunk' },
		s = { '<cmd>Telescope git_status<cr>', 'Git status' },
		b = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
		c = { '<cmd>Telescope git_commits<cr>', 'Checkout commit' },
		d = { '<cmd>Gitsigns diffthis HEAD<cr>', 'Diff' },
	},

	l = {
		name = 'LSP',
		a = { '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Action(s) to fix' },
		d = { '<cmd>Telescope diagnostics bufnr=0<cr>', 'Document diagnostics' },
		f = { '<cmd>lua vim.lsp.buf.format({ async = true })<cr>', 'Format' },
		g = { '<cmd>lua vim.lsp.buf.declaration()<cr>', 'Go to declaration' },
		h = { '<cmd>lua vim.diagnostic.open_float()<cr>', 'Help with error' },
		i = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'Information' },
		j = { '<cmd>lua vim.diagnostic.goto_next()<cr>', 'Next diagnostic' },
		k = { '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'Prev diagnostic' },
		l = { '<cmd>LspInfo<cr>', 'LSP Info' },
		L = { '<cmd>LspInstallInfo<cr>', 'LSP Installer Info' },
		r = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename' },
		v = { '<cmd>lua vim.lsp.buf.references()<cr>', 'View references' },
	},
}

local visual_mappings = {
	c = {
		name = 'Case',
		['.'] = { "<cmd>lua require('textcase').operator('to_dot_case')<cr>", 'Dot case' },
		['-'] = { "<cmd>lua require('textcase').operator('to_dash_case')<cr>", 'Dash case' },
		['_'] = { "<cmd>lua require('textcase').operator('to_snake_case')<cr>", 'Snake case' },
		c = { "<cmd>lua require('textcase').operator('to_camel_case')<cr>", 'Camel case' },
		k = { "<cmd>lua require('textcase').operator('to_constant_case')<cr>", 'Constant case' },
		l = { "<cmd>lua require('textcase').operator('to_lower_case')<cr>", 'Lower case' },
		p = { "<cmd>lua require('textcase').operator('to_pascal_case')<cr>", 'Pascal case' },
		u = { "<cmd>lua require('textcase').operator('to_upper_case')<cr>", 'Upper case' },
	},
}

-- Register keymaps
which_key.setup(setup)
which_key.register(normal_mappings, opts)
which_key.register(visual_mappings, vim.tbl_deep_extend('force', opts, { mode = 'v' }))

-- Other keymaps
which_key.register({
	['/'] = { 'gcc', 'Comment' },
}, vim.tbl_deep_extend('force', opts, { noremap = false }))
