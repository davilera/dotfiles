-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<C-p>", ":bprev<CR>", { desc = "Go to Previews Buffer", remap = true })
map("n", "<C-n>", ":bnext<CR>", { desc = "Go to Next Buffer", remap = true })
