local map = vim.keymap.set

map("v", "<leader>r", '"hy:%s/<C-r>h//gc<left><left><left>', { desc = "Replace" })

-- Paste, reselect, then yank the pasted text to restore unnamed register
map("x", "p", 'pgv"0y')
