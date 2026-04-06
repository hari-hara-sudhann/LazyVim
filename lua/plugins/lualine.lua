return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local palette = {
        bg = "#111111",
        panel = "#1a1a1a",
        deep = "#0b0b0b",
        blue = "#74b2ff",
        cyan = "#7fe4d2",
        green = "#8ccf7e",
        yellow = "#e3c78a",
        orange = "#ff966c",
        red = "#ff5d73",
        magenta = "#c792ea",
        text = "#d6d6d6",
        muted = "#7f8490",
      }

      local mode_colors = {
        n = palette.blue,
        i = palette.green,
        v = palette.magenta,
        V = palette.magenta,
        ["\22"] = palette.magenta,
        c = palette.orange,
        s = palette.yellow,
        S = palette.yellow,
        ["\19"] = palette.yellow,
        R = palette.red,
        r = palette.red,
        t = palette.cyan,
      }

      local chess_sets = {
        { "♔", "♕", "♖", "♗" },
        { "♘", "♙", "♚", "♛" },
        { "♜", "♝", "♞", "♟" },
        { "♔", "♘", "♖", "♙" },
      }

      if not vim.g.chess_index then
        vim.g.chess_index = 1
        local timer = vim.loop.new_timer()
        if timer then
          timer:start(
            0,
            1800,
            vim.schedule_wrap(function()
              vim.g.chess_index = (vim.g.chess_index % #chess_sets) + 1
              local ok, lualine = pcall(require, "lualine")
              if ok then
                lualine.refresh()
              end
            end)
          )
        end
      end

      local function mode_block()
        local mode = vim.fn.mode()
        local names = {
          n = "NORMAL",
          i = "INSERT",
          v = "VISUAL",
          V = "V-LINE",
          ["\22"] = "V-BLOCK",
          c = "COMMAND",
          s = "SELECT",
          S = "S-LINE",
          ["\19"] = "S-BLOCK",
          R = "REPLACE",
          r = "PROMPT",
          t = "TERMINAL",
        }
        return "  " .. (names[mode] or mode:upper()) .. "  "
      end

      local function mode_color()
        return { fg = palette.deep, bg = mode_colors[vim.fn.mode()] or palette.blue, gui = "bold" }
      end

      local function file_icon()
        local ok, devicons = pcall(require, "nvim-web-devicons")
        if not ok then
          return ""
        end
        local name = vim.fn.expand("%:t")
        local ext = vim.fn.expand("%:e")
        local icon = devicons.get_icon(name, ext, { default = true })
        return icon or ""
      end

      local function pretty_filename()
        local name = vim.fn.expand("%:~:.")
        if name == "" then
          return "No File"
        end
        return file_icon() .. " " .. name
      end

      local function workspace_name()
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        return "󰉋 " .. cwd
      end

      local function recording_status()
        local reg = vim.fn.reg_recording()
        if reg == "" then
          return ""
        end
        return "󰑋 @" .. reg
      end

      local function clock()
        return "󰥔 " .. os.date("%H:%M")
      end

      local function chess_bar()
        local pieces = chess_sets[vim.g.chess_index or 1]
        return "▊ " .. table.concat(pieces, " ") .. " ▊"
      end

      local function scroll_bar()
        local bars = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
        local current = vim.fn.line(".")
        local total = vim.fn.line("$")
        if total == 0 then
          return bars[1]
        end
        local index = math.ceil(current / total * #bars)
        return string.rep(bars[math.max(index, 1)], 2)
      end

      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        theme = {
          normal = {
            a = { fg = palette.deep, bg = palette.blue, gui = "bold" },
            b = { fg = palette.text, bg = palette.panel },
            c = { fg = palette.text, bg = palette.bg },
          },
          insert = { a = { fg = palette.deep, bg = palette.green, gui = "bold" } },
          visual = { a = { fg = palette.deep, bg = palette.magenta, gui = "bold" } },
          replace = { a = { fg = palette.deep, bg = palette.red, gui = "bold" } },
          command = { a = { fg = palette.deep, bg = palette.orange, gui = "bold" } },
          inactive = {
            a = { fg = palette.muted, bg = palette.panel },
            b = { fg = palette.muted, bg = palette.panel },
            c = { fg = palette.muted, bg = palette.bg },
          },
        },
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
      })

      opts.sections = {
        lualine_a = {
          {
            mode_block,
            color = mode_color,
            separator = { left = "", right = "" },
            padding = 0,
          },
        },
        lualine_b = {
          {
            "branch",
            icon = "",
            color = { fg = palette.yellow, bg = palette.panel, gui = "bold" },
          },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            diff_color = {
              added = { fg = palette.green },
              modified = { fg = palette.orange },
              removed = { fg = palette.red },
            },
            color = { bg = palette.panel },
          },
        },
        lualine_c = {
          {
            workspace_name,
            color = { fg = palette.cyan, bg = palette.bg, gui = "bold" },
          },
          {
            pretty_filename,
            color = { fg = palette.text, bg = palette.bg },
          },
          {
            recording_status,
            color = { fg = palette.red, bg = palette.bg, gui = "bold" },
          },
        },
        lualine_y = {
          {
            chess_bar,
            color = { fg = palette.yellow, bg = palette.panel, gui = "bold" },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            diagnostics_color = {
              error = { fg = palette.red },
              warn = { fg = palette.orange },
              info = { fg = palette.blue },
              hint = { fg = palette.cyan },
            },
          },
          {
            "filetype",
            icon_only = false,
            colored = true,
            color = { fg = palette.magenta, bg = palette.bg, gui = "bold" },
          },
          {
            "encoding",
            color = { fg = palette.muted, bg = palette.bg },
          },
        },
        lualine_z = {
          {
            function()
              return "󰦨 " .. clock() .. "   " .. vim.fn.line(".") .. ":" .. vim.fn.col(".") .. " " .. scroll_bar()
            end,
            color = mode_color,
            separator = { left = "", right = "" },
            padding = 0,
          },
        },
      }

      opts.inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            pretty_filename,
            color = { fg = palette.muted, bg = palette.bg },
          },
        },
        lualine_x = {
          {
            "location",
            color = { fg = palette.muted, bg = palette.bg },
          },
        },
        lualine_y = {
          {
            chess_bar,
            color = { fg = palette.muted, bg = palette.panel },
          },
        },
        lualine_z = {},
      }

      opts.extensions = vim.list_extend(opts.extensions or {}, {
        "neo-tree",
        "lazy",
        "mason",
        "quickfix",
        "toggleterm",
      })

      return opts
    end,
  },
}
