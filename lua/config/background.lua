vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        local groups = {
            "Normal",
            "NormalNC",
            "NormalFloat",
            "FloatBorder",
            "SignColumn",
            "FoldColumn",
            "LineNr",
            "CursorLineNr",
            "EndOfBuffer",
            "MsgArea",
            "NvimTreeNormal",
            "NvimTreeNormalNC",
        }

        for _, group in ipairs(groups) do
            vim.api.nvim_set_hl(0, group, { bg = "none" })
        end

        local lualine_groups = {
          "LualineModeSel",
          "LualineModeNorm",
          "LualineModeIns",
          "LualineModeVis",
          "LualineModeViss",
          "LualineModeVib",
          "LualineModeComm",
          "LualineModeOpp",
          "LualineModeRep",
          "LualineModeRepl",
          "LualineModeTerm",
          "LualineComp",
          "LualineTab",
          "LualineTabActive",
          "LualineTabInc",
          "LualineYank",
        }

        for _, group in ipairs(lualine_groups) do
            vim.api.nvim_set_hl(0, group, { bg = "none", fg = "none" })
        end
    end,
})
