return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      prettier = {
        command = vim.env.HOME .. "/.nvm/versions/node/v20.12.2/bin/prettier",
      },
      phpcbf = {
        command = vim.env.HOME .. "/.config/composer/vendor/bin/phpcbf",
        args = {
          "-q",
          "-",
        },
        stdin = true,
      },
      stylelint = {
        command = vim.env.HOME .. "/.nvm/versions/node/v20.12.2/bin/stylelint",
        args = { "--fix" },
      },
    },
    formatters_by_ft = {
      css = { "prettier", "stylelint" },
      scss = { "prettier", "stylelint" },
      php = { "phpcbf" },
    },
  },
}
