return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true,
      show_end_of_buffer = true,
      term_colors = true,
      integrations = {
        fidget = true,
        harpoon = true,
        mason = true,
        native_lsp = {
          underlines = {
            errors = { "undercurl" },
            warnings = { "undercurl" },
            hints = { "undercurl" },
            information = { "undercurl" },
          },
        },
        treesitter_context = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      view = {
        number = true,
        relativenumber = true,
        float = {
          enable = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * 0.5
            local window_h = screen_h * 0.8
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
            return {
              border = "rounded",
              relative = "editor",
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * 0.5)
        end,
      },
    },
    -- stylua: ignore
    cmds = {
      "NvimTreeClipboard", "NvimTreeClose", "NvimTreeCollapse",
      "NvimTreeCollapseKeepBuffers", "NvimTreeFindFile",
      "NvimTreeFindFileToggle", "NvimTreeFocus", "NvimTreeOpen",
      "NvimTreeRefresh", "NvimTreeResize", "NvimTreeToggle",
    },
    keys = {
      { "<Leader>t", "<Cmd>NvimTreeToggle<CR>", desc = "NvimTree Toggle" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local icons = require("lsvmello.icons")
      return {
        options = {
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_b = {
            "branch",
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
          },
          lualine_c = {
            "%=",
            { "filetype", icon_only = true, separator = "", padding = 0 },
            { "filename", path = 1, symbols = { modified = "", readonly = "" } },
          },
          lualine_x = { "encoding" },
          lualine_y = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            }
          },
          lualine_z = { "location" },
        },
      }
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        height = 0.9,
        options = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
          list = false,
          cursorline = false,
          cursorcolumn = false,
        },
      },
    },
    dependencies = {
      { "folke/twilight.nvim", config = true },
    },
  },
}
