local map = vim.keymap.set

map("n", "<C-p>", "<cmd>bprev<cr><esc>", { desc = "Go to Previews Buffer", remap = true })
map("n", "<C-n>", "<cmd>bnext<cr><esc>", { desc = "Go to Next Buffer", remap = true })
