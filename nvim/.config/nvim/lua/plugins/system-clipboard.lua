return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        {
          "<leader>y",
          '"+y',
          mode = "v",
          desc = "Yank to system clipboard",
        },
        {
          "<leader>Y",
          ":%y+<CR>",
          desc = "Yank file to system clipboard",
        },
      },
    },
  },
}
