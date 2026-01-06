-- ~/.config/nvim/lua/plugins/minipairs-tex.lua
return {
  "nvim-mini/mini.pairs",
  opts = function(_, opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "tex", "plaintex", "latex" },
      callback = function()
        -- Disable MiniPairs completely for this buffer
        vim.b.minipairs_disable = true
      end,
    })

    return opts
  end,
}

