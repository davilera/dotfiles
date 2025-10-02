return {
  "mfussenegger/nvim-lint",
  opts = {
    linters = {
      phpcs = {
        cmd = vim.env.HOME .. "/.config/composer/vendor/bin/phpcs",
      },
    },
    linters_by_ft = {
      css = { "stylelint" },
      scss = { "stylelint" },
      php = { "phpstan", "phpcs" },
    },
  },
}
