return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        mode = { "n", "v" },
        { "<leader>w", nil },
        { "<leader>q", nil },
      },
    },
  },
  {
    "folke/persistence.nvim",
    enabled = false,
  },
}
