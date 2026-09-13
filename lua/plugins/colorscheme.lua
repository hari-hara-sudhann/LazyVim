return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha",
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            }
        }
    },
  { "ellisonleao/gruvbox.nvim" },
{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
