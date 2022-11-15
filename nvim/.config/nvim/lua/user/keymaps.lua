local keymap = vim.api.nvim_set_keymap -- alias
local opts = { noremap = true, silent = true }

-- Remap space as leader key
keymap('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ------
-- NORMAL
-- ------

-- Helpers
keymap('n', '<Leader>w', ':w!<CR>', opts)
keymap('n', '<Leader>q', ':q<CR>', opts)

-- Switch windows faster
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- Resize windows with arrows
keymap('n', '<C-Up>', ':resize +2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)
keymap('n', '<C-Down>', ':resize -2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)

-- Navigate buffers
keymap('n', '<S-l>', ':bnext<CR>', opts)
keymap('n', '<S-h>', ':bprevious<CR>', opts)
keymap('n', '_', ':BdeleteSmart<CR>', opts)

-- Move text up and down
keymap('n', '<A-j>', ':move .+1<CR>==', opts)
keymap('n', '<A-k>', ':move .-2<CR>==', opts)

-- Nvimtree and Telescope
keymap('n', '<Leader>e', ':NvimTreeSmartToggle<CR>', {})
keymap('n', '<Leader>f', ':Telescope find_files<CR>', opts) -- [F]ind file
keymap('n', '<Leader>t', ':Telescope live_grep<CR>', opts) -- Grep [T]ext

-- ------
-- VISUAL
-- ------

-- Stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Move text up and down
keymap('v', '<A-j>', ":move '>+1<CR>gv=gv", opts)
keymap('v', '<A-k>', ":move '<-2<CR>gv=gv", opts)
