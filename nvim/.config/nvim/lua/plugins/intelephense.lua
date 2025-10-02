return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      intelephense = {
        settings = {
          intelephense = {
            files = {
              maxSize = 1000000000,
              exclude = {
                "**/.git/**",
                "**/.svn/**",
                "**/.hg/**",
                "**/CVS/**",
                "**/.DS_Store/**",
                "**/node_modules/**",
                "**/bower_components/**",
                "**/vendor/**/{Tests,tests}/**",
                "**/.history/**",
                "**/vendor/**/vendor/**",
                "**/.lando/**",
              },
            },
            environment = {
              includePaths = {
                vim.env.HOME .. "/.config/composer/vendor/php-stubs",
                "./stubs/compat.php",
              },
            },
          },
        },
      },
    },
  },
}
