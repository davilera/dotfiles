local map = vim.keymap.set

map("v", "<leader>r", '"hy:%s/<C-r>h//gc<left><left><left>', { desc = "Replace" })
