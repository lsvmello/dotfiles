return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      show_end_of_buffer = true,
      term_colors = true,
      default_integrations = false,
      integrations = {
        blink_cmp = true,
        dap = true,
        dap_ui = true,
        diffview = true,
        fidget = true,
        gitsigns = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
            ok = { "undercurl" },
          },
          inlay_hints = {
            background = true,
          },
        },
        navic = {
          enabled = true,
        },
        render_markdown = true,
        telescope = false,
        treesitter = true,
        treesitter_context = true,
      },
      custom_highlights = function(C)
        return {
          TelescopeBorder = { fg = C.mantle, bg = C.mantle, },
          TelescopeMatching = { fg = C.blue },
          TelescopeNormal = { bg = C.mantle, },
          TelescopePromptBorder = { fg = C.crust, bg = C.crust, },
          TelescopePromptNormal = { fg = C.text, bg = C.crust, },
          TelescopePromptPrefix = { fg = C.flamingo, bg = C.crust, },
          TelescopePromptTitle = { fg = C.red, bg = C.crust, },
          TelescopeResultsTitle = { fg = C.lavender, bg = C.mantle, },
          TelescopePreviewTitle = { fg = C.green, bg = C.mantle, },
          TelescopeSelection = { fg = C.flamingo, bg = C.mantle, style = { "bold" }, },
          TelescopeSelectionCaret = { fg = C.flamingo },
          NavicText = { fg = C.text },
        }
      end,
    },
    init = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    dependencies = { "echasnovski/mini.nvim" }, -- mini.icons dependency
    config = function()
      require("lualine").setup({
        options = {
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            winbar = { "fugitive", "oil", "qf", "terminal", "undotree", "diff", }
          },
        },
        sections = {
          lualine_a = { { "mode", }, },
          lualine_b = {
            { "b:gitsigns_head", icon = "", },
            {
              "diff",
              symbols = require("custom.icons").git,
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed
                  }
                end
              end,
            },
          },
          lualine_c = {
            require("custom.lualine").statusline_filename,
          },
          lualine_x = {
            require("custom.toggler").status,
            "diagnostics",
            "filetype",
          },
          lualine_y = {
            "location",
          },
          lualine_z = { "progress" },
        },
        tabline = {
          lualine_a = {
            {
              'tabs',
              mode = 2,
              max_length = vim.o.columns,
              use_mode_colors = true,
              show_modified_status = true,
              cond = function()
                vim.o.showtabline = 1
                return true
              end,
            },
          },
        },
        winbar = {
          lualine_a = { { "filetype", colored = false, icon_only = true, padding = { left = 1, right = 0, }, }, },
          lualine_c = {
            {
              require("custom.lualine").winbar_filename,
              path = 0,
              symbols = {
                modified = "●",
                readonly = "",
              },
              separator = "",
            },
            {
              function()
                return require("nvim-navic").get_location()
              end,
              cond = function()
                return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
              end,
            },
          },
        },
        inactive_winbar = {
          lualine_a = { { "filetype", colored = false, icon_only = true, padding = { left = 1, right = 0, }, }, },
          lualine_c = {
            {
              require("custom.lualine").winbar_filename,
              path = 0,
              file_status = true,
              symbols = {
                modified = "●",
                readonly = "",
              },
            },
            {
              "diff",
              colored = false,
              icon = "",
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed
                  }
                end
              end,
            },
            { "diagnostics", colored = false, },
          },
        },
        extensions = {
          "fugitive", "lazy", "man",
          "mason", "nvim-dap-ui", "oil",
          "overseer", "quickfix",
        },
      })
    end,
  },
  {
    "mawkler/modicator.nvim",
    event = "ModeChanged",
    opts = {},
  },
  {
    'stevearc/dressing.nvim',
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end

      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
}
