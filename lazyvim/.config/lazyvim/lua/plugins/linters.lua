return {
  "mfussenegger/nvim-lint",
  opts = {
    linters = {
      phpcs = {
        cmd = vim.fn.exepath("phpcs"),
      },
    },
    linters_by_ft = {
      css = { "stylelint" },
      scss = { "stylelint" },
      php = { "phpstan", "phpcs" },
    },
  },
}
