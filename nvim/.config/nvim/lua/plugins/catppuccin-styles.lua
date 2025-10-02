return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = {
      transparent_background = false,
      term_colors = true,
      integrations = {
        bufferline = true,
      },
      styles = {
        conditionals = { "bold" },
        loops = { "bold" },
        keywords = { "bold" },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    -- HACK. Workaround until this is merged https://github.com/LazyVim/LazyVim/pull/6354
    init = function()
      local bufline = require("catppuccin.groups.integrations.bufferline")
      function bufline.get()
        return bufline.get_theme()
      end
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
