return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  enabled = false,
                },
                mccabe = {
                  enabled = false,
                },
                pyflakes = {
                  enabled = true,
                },
              },
            },
          },
        },
      },
    },
  },
}
