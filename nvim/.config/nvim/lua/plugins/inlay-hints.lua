local inlayHints = {
  parameterNames = { enabled = "none" },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = { inlayHints = inlayHints },
            javascript = { inlayHints = inlayHints },
          },
        },
      },
    },
  },
}
