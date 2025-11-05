return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        DEPRECATED = { icon = " ", color = "warning" },
        REVIEW = { icon = " ", color = "warning" },
        DEBUG = { icon = " ", color = "warning" },
        NOTE = { icon = " ", color = "hint", alt = { "INFO", "DOC" } },
      },
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*[.:]?]],
      },
      search = {
        pattern = [[\b(KEYWORDS)[:.]?]],
      },
    },
  },
}
