return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)

      --------------------------------------------------
      -- Chess Piece Sets
      --------------------------------------------------
      local chess_sets = {
        { "♔", "♕", "♖", "♗" },
        { "♘", "♙", "♚", "♛" },
        { "♜", "♝", "♞", "♟" },
        { "♔", "♘", "♖", "♙" },
      }

      --------------------------------------------------
      -- Global State (only create once)
      --------------------------------------------------
      if not vim.g.chess_index then
        vim.g.chess_index = 1

        local timer = vim.loop.new_timer()
        timer:start(
          0,
          2000, -- 2 seconds
          vim.schedule_wrap(function()
            vim.g.chess_index =
              (vim.g.chess_index % #chess_sets) + 1

            require("lualine").refresh()
          end)
        )
      end

      --------------------------------------------------
      -- Chess Component
      --------------------------------------------------
      local function chess_bar()
        local pieces = chess_sets[vim.g.chess_index]
        return table.concat(pieces, " ")
      end

      --------------------------------------------------
      -- Replace Center Section
      --------------------------------------------------
      opts.sections.lualine_c = {
        {
          chess_bar,
          color = { fg = "#e3c78a", gui = "bold" }, -- moonfly yellow
        },
      }

      return opts
    end,
  },
}
