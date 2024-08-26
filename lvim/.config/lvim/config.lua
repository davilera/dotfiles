-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- =======================================================
--   BASIC SETUP
-- =======================================================

local ok, catppuccin = pcall(require, 'catppuccin')
if ok then
	lvim.colorscheme = 'catppuccin-mocha'
	catppuccin.setup({
		transparent_background = true,
		styles = {
			conditionals = { 'bold' },
			loops = { 'bold' },
			keywords = { 'bold' },
		},
	})
end

local options = {
	backupdir = '/tmp',      -- location of swap files
	clipboard = '',          -- disable integration with system clipboard
	cmdheight = 2,           -- more space in neovim’s command line for displaying messages
	cursorline = false,      -- highlight current line
	cursorlineopt = 'number', -- highlight current line
	encoding = 'utf-8',      -- fix encoding
	hidden = true,           -- prefer hiding over unloading buffers
	hlsearch = true,         -- highlight search
	mouse = '',              -- disable mouse
	number = true,           -- show line numbers (current line only when combined with relative numbers)
	path = '.,,',            -- search relative to current file + directory
	relativenumber = true,   -- show relative numbers
	scrolloff = 0,           -- keep no context around current line
	shiftwidth = 2,          -- indentation defaults (<< / >> / == / auto)
	sidescrolloff = 0,       -- keep no context around current line
	smartindent = true,      -- try to guess current indentation level
	spell = true,            -- check spelling in comments and text files
	splitbelow = true,       -- prefer new horizontal split below
	splitright = true,       -- prefer new vertical split to the right
	tabstop = 2,             -- tab characters take two spaces only
	title = false,           -- disable title string
	undolevels = 100,        -- number of undo levels
	updatetime = 300,        -- faster autocomplete
	wrap = false,            -- wrap long lines
}

for k, v in pairs(options) do
	vim.opt[k] = v
end


-- =======================================================
--   CUSTOM PLUGINS
-- =======================================================

lvim.plugins = {
	-- Colorschemes
	{ 'rose-pine/neovim' },
	{
		'catppuccin/nvim',
		name = 'catppuccin',
	},

	-- Async Format on Save
	{
		'lukas-reineke/lsp-format.nvim',
		opts = {},
	},

	-- Tab/space behavior
	{
		'FotiadisM/tabset.nvim',
		opts = {
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
		opts = {
			render = 'background',
			enabled_named_colors = true,
		},
	},

	-- Show marks
	{
		'chentoast/marks.nvim',
		opts = {
			default_mappings = true,
			signs = true,
			mappings = {},
		}
	},

	-- Text case conversions
	{ 'johmsalas/text-case.nvim' },

	-- Treesitter text objects
	{
		'nvim-treesitter/nvim-treesitter-textobjects',
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require 'nvim-treesitter.configs'.setup {
				textobjects = {
					select = {
						enable = true,
						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ai"] = "@conditional.outer",
							["ii"] = "@conditional.inner",
							["al"] = "@loop.outer",
							["il"] = "@loop.inner",
							["at"] = "@comment.outer",
							-- You can also use captures from other query groups like `locals.scm`
							-- ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
						},
						selection_modes = {
							['@parameter.outer'] = 'v', -- charwise
							['@function.outer'] = 'V', -- linewise
							['@class.outer'] = '<c-v>', -- blockwise
						},
						include_surrounding_whitespace = true,
					},
					move = {
						enable = true,
						set_jumpts = true,
						goto_next_start = {
							[']f'] = '@function.outer',
						},
						goto_next_end = {
							[']F'] = '@function.outer',
						},
						goto_previous_start = {
							['[f'] = '@function.outer',
						},
						goto_previous_end = {
							['[F'] = '@function.outer',
						},
					}
				},
			}
		end,
		dependencies = "nvim-treesitter/nvim-treesitter",
	},

	-- LSP status
	{ 'arkav/lualine-lsp-progress' },

	-- Undo Tree
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = {
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
		},
	}
}

-- Remove marks when opening file
vim.api.nvim_create_autocmd({ "BufRead" }, { command = ":delm a-zA-Z0-9", })


-- =======================================================
--   LVIM BUILTIN TWEAKS
-- =======================================================

lvim.format_on_save.enabled = true
lvim.format_on_save.timeout = 5000

lvim.builtin.autopairs.active = false
lvim.builtin.bufferline.options.show_buffer_close_icons = false
lvim.builtin.indentlines.active = false
lvim.builtin.project.manual_mode = true
lvim.builtin.which_key.setup.plugins['better-marks'] = true
-- lvim.builtin.which_key.setup.plugins['better-registers'] = true
-- lvim.lsp.on_attach_callback = require('lsp-format').on_attach
lvim.builtin.treesitter.ensure_installed = {
	'comment',
	'css',
	'elm',
	'haskell',
	'html',
	'java',
	'javascript',
	'lua',
	'markdown',
	'php',
	'regex',
	'rust',
	'typescript',
}

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

-- =======================================================
--   SHORTCUTS
-- =======================================================

--------------------------------
---- Utils ---------------------
--------------------------------
lvim.builtin.which_key.mappings['f'] = nil
lvim.builtin.which_key.mappings['s']['g'] = lvim.builtin.which_key.mappings['s']['t']

-- Replace visual selection
lvim.builtin.which_key.vmappings['r'] = { '"hy:%s/<C-r>h//gc<left><left><left>', 'Replace' }
lvim.builtin.which_key.vmappings['s'] = { 'y/<C-r>"<cr>', 'Search' }

-- Move lines (TODO)
-- lvim.keys.normal_mode['<C-J>'] = ':m .+1<CR>==';
-- lvim.keys.insert_mode['<C-J>'] = '<Esc>:m .+1<CR>==gi';
-- lvim.keys.visual_mode['<C-J>'] = ":m '>+1<CR>gv-gv";

-- lvim.keys.insert_mode['<C-K>'] = '<Esc>:m .-2<CR>==gi';
-- lvim.keys.normal_mode['<C-K>'] = ':m .-2<CR>==';
-- lvim.keys.visual_mode['<C-K>'] = ":m '<-2<CR>gv-gv";

--------------------------------
---- Git -----------------------
--------------------------------
lvim.builtin.which_key.mappings['g']['q'] = {
	"<C-w>h:lua if vim.api.nvim_buf_get_name(0):find('^gitsigns:') ~= nil then vim.cmd(':q') end<cr>",
	'Close diff'
}

--------------------------------
---- Tab Movement --------------
--------------------------------
lvim.keys.normal_mode['<C-n>'] = ':bnext<cr>';
lvim.keys.normal_mode['<C-p>'] = ':bprev<cr>';

--------------------------------
---- Save ----------------------
--------------------------------
lvim.builtin.which_key.mappings['w'] = { ':w<cr>', 'Save' }
lvim.builtin.which_key.mappings['W'] = { ':wall<cr>', 'Save all' }

--------------------------------
---- Close app/tab -------------
--------------------------------
local function quit()
	local bufs = vim.fn.getbufinfo({ buflisted = 1 })
	if 1 < #bufs then
		vim.cmd(':confirm bdelete')
	elseif bufs[1] then
		vim.cmd(':confirm bdelete')
		vim.cmd(':Alpha')
		local empty = vim.fn.getbufinfo({ buflisted = 1 })[1]['bufnr']
		vim.cmd(string.format(':%dbunload', empty))
	else
		vim.cmd(':confirm qall')
	end
end
lvim.builtin.which_key.mappings['q'] = { quit, 'Close tab' }
lvim.builtin.which_key.mappings['Q'] = { ':confirm qall<cr>', 'Force quit' }

--------------------------------
---- Splits --------------------
--------------------------------
lvim.builtin.which_key.mappings['v'] = { ':vs<cr>', 'Vertical split' }
lvim.builtin.which_key.mappings['x'] = { ':sp<cr>', 'Horizontal split' }
lvim.builtin.which_key.mappings['k'] = {
	":lua if #vim.api.nvim_tabpage_list_wins(0) > 1 then vim.cmd(':q') end<cr>",
	'Close split'
}

--------------------------------
---- Configure smart case ------
--------------------------------
lvim.builtin.which_key.mappings['c'] = {
	name = 'Case',
	['.'] = { ":lua require('textcase').current_word('to_dot_case')<cr>", 'Dot case' },
	['-'] = { ":lua require('textcase').current_word('to_dash_case')<cr>", 'Dash case' },
	['_'] = { ":lua require('textcase').current_word('to_snake_case')<cr>", 'Snake case' },
	c = { ":lua require('textcase').current_word('to_camel_case')<cr>", 'Camel case' },
	k = { ":lua require('textcase').current_word('to_constant_case')<cr>", 'Constant case' },
	l = { ":lua require('textcase').current_word('to_lower_case')<cr>", 'Lower case' },
	p = { ":lua require('textcase').current_word('to_pascal_case')<cr>", 'Pascal case' },
	u = { ":lua require('textcase').current_word('to_upper_case')<cr>", 'Upper case' },
}
lvim.builtin.which_key.vmappings['c'] = {
	name = 'Case',
	['.'] = { ":lua require('textcase').operator('to_dot_case')<cr>", 'Dot case' },
	['-'] = { ":lua require('textcase').operator('to_dash_case')<cr>", 'Dash case' },
	['_'] = { ":lua require('textcase').operator('to_snake_case')<cr>", 'Snake case' },
	c = { ":lua require('textcase').operator('to_camel_case')<cr>", 'Camel case' },
	k = { ":lua require('textcase').operator('to_constant_case')<cr>", 'Constant case' },
	l = { ":lua require('textcase').operator('to_lower_case')<cr>", 'Lower case' },
	p = { ":lua require('textcase').operator('to_pascal_case')<cr>", 'Pascal case' },
	u = { ":lua require('textcase').operator('to_upper_case')<cr>", 'Upper case' },
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
	':lua vim.lsp.buf.hover()<cr>', 'Information'
}
lvim.builtin.which_key.mappings['l']['Q'] = lvim.builtin.which_key.mappings['l']['d']

local function nilget(t, ...)
	for i = 1, select("#", ...) do
		if t == nil then return nil end
		t = t[select(i, ...)]
	end
	return t
end

local function gotoDefinition()
	local current_file = 'file://' .. vim.api.nvim_buf_get_name(0)
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local definition = vim.lsp.buf_request_sync(vim.fn.bufnr(), 'textDocument/definition', {
		textDocument = { uri = current_file },
		position = { line = cursor_position[1], character = cursor_position[2] },
	})
	local definition_file = nilget(definition, 1, 'result', 1, 'targetUri') or current_file
	-- print(vim.inspect(definition))
	-- print('C:' .. current_file .. ' D:' .. definition_file)
	if current_file ~= definition_file then
		local num_of_splits = #vim.api.nvim_tabpage_list_wins(0)
		if 1 == num_of_splits then
			vim.cmd('vsplit')
		else
			vim.cmd(vim.api.nvim_replace_termcodes('normal 20<C-w>l', true, true, true))
			vim.cmd(vim.api.nvim_replace_termcodes('normal 20<C-w>j', true, true, true))
			vim.cmd('split')
		end
	end
	vim.lsp.buf.definition()
end
lvim.builtin.which_key.mappings['l']['d'] = { gotoDefinition, 'Jump to definition' }


-- =======================================================
--   LINTERS/FORMATTERS
-- =======================================================

local function getPhpcbfStandard()
	if 0 == vim.fn.filereadable('./phpcs.ruleset.xml') then
		return '--standard=WordPress'
	else
		return '--standard=phpcs.ruleset.xml'
	end
end

local formatters = require 'lvim.lsp.null-ls.formatters'
formatters.setup({
	{
		name = 'phpcbf',
		command = '~/.config/composer/vendor/bin/phpcbf',
		args = { '-q', '--stdin-path=$FILENAME', getPhpcbfStandard(), '-' }
	},
	{
		name = 'prettier',
		filetypes = { 'javascript', 'json', 'typescript', 'typescriptreact' },
	},
	{
		name = 'stylelint',
		filetypes = { 'css', 'scss' },
	},
})

local linters = require 'lvim.lsp.null-ls.linters'
linters.setup({
	{
		name = 'eslint_d',
		filetypes = { 'javascript', 'typescript', 'typescriptreact' },
	},
	{
		name = 'stylelint',
		filetypes = { 'css', 'scss' },
	},
})
