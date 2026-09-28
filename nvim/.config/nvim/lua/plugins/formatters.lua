return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      prettier = {
        command = vim.env.NVM_BIN .. "/prettier",
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
        command = vim.env.NVM_BIN .. "/stylelint",
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
