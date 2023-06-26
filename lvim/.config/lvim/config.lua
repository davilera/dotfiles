-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- =======================================================
--   BASIC SETUP
-- =======================================================

lvim.colorscheme = 'tokyonight-night'
lvim.format_on_save.enabled = true
lvim.format_on_save.timeout = 5000

lvim.builtin.autopairs.active = false
lvim.builtin.bufferline.options.show_buffer_close_icons = false
lvim.builtin.indentlines.active = false
lvim.builtin.project.manual_mode = true

lvim.builtin.lualine.sections.lualine_x = {
	{
		'lsp_progress',
		display_components = { 'spinner' },
		spinner_symbols = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
	},
	require('lvim.core.lualine.components').diagnostics,
	require('lvim.core.lualine.components').lsp,
	require('lvim.core.lualine.components').filetype,
}

local options = {
	backupdir = '/tmp',    -- location of swap files
	clipboard = '',        -- disable integration with system clipboard
	cmdheight = 2,         -- more space in neovim’s command line for displaying messages
	cursorline = true,     -- highlight current line
	cursorlineopt = 'both', -- highlight current line
	encoding = 'utf-8',    -- fix encoding
	hidden = true,         -- prefer hiding over unloading buffers
	hlsearch = true,       -- highlight search
	mouse = '',            -- disable mouse
	number = true,         -- show line numbers (current line only when combined with relative numbers)
	path = '.,,',          -- search relative to current file + directory
	relativenumber = true, -- show relative numbers
	scrolloff = 8,         -- keep some context around current line
	sidescrolloff = 8,     -- keep some context around current line
	shiftwidth = 2,        -- indentation defaults (<< / >> / == / auto)
	smartindent = true,    -- try to guess current indentation level
	splitbelow = true,     -- prefer new horizontal split below
	splitright = true,     -- prefer new vertical split to the right
	tabstop = 2,           -- tab characters take two spaces only
	title = false,         -- disable title string
	updatetime = 300,      -- faster autocomplete
	undolevels = 100,      -- number of undo levels
	wrap = false,          -- wrap long lines
}

for k, v in pairs(options) do
	vim.opt[k] = v
end


-- =======================================================
--   CUSTOM PLUGINS
-- =======================================================

lvim.plugins = {
	-- Tab/space behavior
	{
		'FotiadisM/tabset.nvim',
		config = {
			defaults = {
				tabwidth = 2,
				expandtab = false,
			},
			languages = {
				elm = {
					tabwidth = 4,
					expandtab = true,
				},
				haskell = {
					tabwidth = 4,
					expandtab = true,
				},
				markdown = {
					tabwidth = 2,
					expandtab = true,
				},
				yaml = {
					tabwidth = 4,
					expandtab = true,
				},
			},
		},
	},

	-- Colors preview
	{
		'brenoprata10/nvim-highlight-colors',
		config = {
			render = 'background',
			enabled_named_colors = true,
		},
	},

	-- Show marks
	{
		'chentoast/marks.nvim',
		config = {
			default_mappings = true,
			signs = true,
			mappings = {},
		}
	},

	-- Text case conversions
	{ 'johmsalas/text-case.nvim' },

	-- LSP status
	{ 'arkav/lualine-lsp-progress' }
}

-- Remove marks when opening file
vim.api.nvim_create_autocmd({ "BufRead" }, { command = ":delm a-zA-Z0-9", })


-- =======================================================
--   SHORTCUTS
-- =======================================================

--------------------------------
---- Tab Movement --------------
--------------------------------
lvim.keys.normal_mode['L'] = ':bnext<cr>';
lvim.keys.normal_mode['H'] = ':bprev<cr>';

--------------------------------
---- Find/Grep files -----------
--------------------------------
lvim.builtin.which_key.mappings['f'] = lvim.builtin.which_key.mappings['s']['f']
lvim.builtin.which_key.mappings['t'] = lvim.builtin.which_key.mappings['s']['t']

--------------------------------
---- Save ----------------------
--------------------------------
lvim.builtin.which_key.mappings['S'] = lvim.builtin.which_key.mappings['s']
lvim.builtin.which_key.mappings['s'] = lvim.builtin.which_key.mappings['w']
lvim.builtin.which_key.mappings['b']['s'] = lvim.builtin.which_key.mappings['b']['W']
lvim.builtin.which_key.mappings['b']['W'] = nil

--------------------------------
---- Close app/tab -------------
--------------------------------
local function closeTabAndSplit()
	local files = #vim.fn.getbufinfo({ buflisted = 1 })
	local splits = #vim.api.nvim_tabpage_list_wins(0)

	vim.cmd(':BufferKill');
	local dirty = 1 == vim.fn.getbufinfo()[vim.fn.bufnr()].changed
	if 1 == files then
		if not dirty then
			vim.cmd(':q')
		end
	elseif not dirty and splits > 1 then
		vim.cmd(':q')
	end
end

lvim.builtin.which_key.mappings['Q'] = { ':confirm qall<cr>', 'Force quit' }
lvim.builtin.which_key.mappings['w'] = { closeTabAndSplit, 'Close tab' }
lvim.builtin.which_key.mappings['W'] = { ':BufferKill<cr>', 'Close tab (keep split)' }
lvim.builtin.which_key.mappings['F'] = lvim.builtin.which_key.mappings['b']['W']

--------------------------------
---- Configure smart case ------
--------------------------------
lvim.builtin.which_key.mappings['c'] = {
	name = 'Case',
	['.'] = { "<cmd>lua require('textcase').current_word('to_dot_case')<cr>", 'Dot case' },
	['-'] = { "<cmd>lua require('textcase').current_word('to_dash_case')<cr>", 'Dash case' },
	['_'] = { "<cmd>lua require('textcase').current_word('to_snake_case')<cr>", 'Snake case' },
	c = { "<cmd>lua require('textcase').current_word('to_camel_case')<cr>", 'Camel case' },
	k = { "<cmd>lua require('textcase').current_word('to_constant_case')<cr>", 'Constant case' },
	l = { "<cmd>lua require('textcase').current_word('to_lower_case')<cr>", 'Lower case' },
	p = { "<cmd>lua require('textcase').current_word('to_pascal_case')<cr>", 'Pascal case' },
	u = { "<cmd>lua require('textcase').current_word('to_upper_case')<cr>", 'Upper case' },
}
lvim.builtin.which_key.vmappings['c'] = {
	name = 'Case',
	['.'] = { "<cmd>lua require('textcase').operator('to_dot_case')<cr>", 'Dot case' },
	['-'] = { "<cmd>lua require('textcase').operator('to_dash_case')<cr>", 'Dash case' },
	['_'] = { "<cmd>lua require('textcase').operator('to_snake_case')<cr>", 'Snake case' },
	c = { "<cmd>lua require('textcase').operator('to_camel_case')<cr>", 'Camel case' },
	k = { "<cmd>lua require('textcase').operator('to_constant_case')<cr>", 'Constant case' },
	l = { "<cmd>lua require('textcase').operator('to_lower_case')<cr>", 'Lower case' },
	p = { "<cmd>lua require('textcase').operator('to_pascal_case')<cr>", 'Pascal case' },
	u = { "<cmd>lua require('textcase').operator('to_upper_case')<cr>", 'Upper case' },
}

--------------------------------
---- Remap LSP shortcuts -------
--------------------------------
lvim.builtin.which_key.mappings['l']['M'] = lvim.builtin.which_key.mappings['l']['I']
lvim.builtin.which_key.mappings['l']['L'] = {
	lvim.builtin.which_key.mappings['l']['i'][1],
	'LSP Info'
}
lvim.builtin.which_key.mappings['l']['I'] = nil
lvim.builtin.which_key.mappings['l']['i'] = {
	'<cmd>lua vim.lsp.buf.hover()<cr>', 'Information'
}


-- =======================================================
--   LINTERS/FORMATTERS
-- =======================================================

local formatters = require 'lvim.lsp.null-ls.formatters'
formatters.setup({
	{
		name = 'phpcbf',
		command = './vendor/bin/phpcbf',
		args = { '-q', '--stdin-path=$FILENAME', '--standard=phpcs.ruleset.xml', '-' },
	},
	{
		name = 'prettier',
		filetypes = { 'javascript', 'typescript', 'typescriptreact' },
	}
})


local linters = require 'lvim.lsp.null-ls.linters'
linters.setup({
	{
		name = 'prettier',
		filetypes = { 'javascript', 'typescript', 'typescriptreact' },
	},
	{
		name = 'eslint_d',
		filetypes = { 'javascript', 'typescript', 'typescriptreact' },
	},
})
