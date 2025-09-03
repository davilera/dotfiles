local unmap = vim.keymap.del
unmap("n", "<leader>wd")
unmap("n", "<leader>wm")
unmap("n", "<leader>qd")
unmap("n", "<leader>ql")
unmap("n", "<leader>qq")
unmap("n", "<leader>qs")
unmap("n", "<leader>qS")

local map = vim.keymap.set
map("n", "<leader>w", "<cmd>:w<cr>", { desc = "Save" })
map("n", "<leader>W", "<cmd>:wall<cr>", { desc = "Save all" })

local function quit()
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  if 1 < #bufs then
    vim.cmd(":confirm bdelete")
  else
    vim.cmd(":confirm qall")
  end
end
map("n", "<leader>q", quit, { desc = "Close tab" })
map("n", "<leader>Q", "<cmd>:confirm qall<cr>", { desc = "Force quit" })
