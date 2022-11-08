local keymap = vim.api.nvim_set_keymap -- alias
local opts = { noremap = true, silent = true }

-- Remap space as leader key
keymap('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ------
-- NORMAL
-- ------

-- Navigate buffers
keymap('n', '<S-l>', ':bnext<CR>', opts)
keymap('n', '<S-h>', ':bprevious<CR>', opts)
keymap('n', '_', ':Bdelete!<CR>', opts)

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

-- Switch buffers
keymap('n', '<C-p>', ':bprev<CR>', opts)
keymap('n', '<C-n>', ':bnext<CR>', opts)

-- Move text up and down
keymap('n', '<A-j>', ':move .+1<CR>==', opts)
keymap('n', '<A-k>', ':move .-2<CR>==', opts)

-- Nvimtree
keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', opts)

-- ------
-- VISUAL
-- ------

-- Stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Move text up and down
keymap('v', '<A-j>', ":move '>+1<CR>gv=gv", opts)
keymap('v', '<A-k>', ":move '<-2<CR>gv=gv", opts)
