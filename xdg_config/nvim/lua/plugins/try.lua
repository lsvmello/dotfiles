return {
  -- database integration
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod',                     lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    -- INFO: Try to use :make (see youtube video about it)
    "ej-shafran/compile-mode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "m00qek/baleia.nvim", -- no need for `setup()`?
    },
    cmd = {
      "Compile", "CurrentError", "FirstError", "NextError",
      "NextErrorFollow", "PrevError", "QuickfixErrors", "Recompile",
    },
    config = function()
      -- No setup function
      -- WARN: has bad-namining files on /plugin folder
      vim.g.compile_mode = {
        baleia_setup = true,
      }
    end,
  },
  -- TODO: try this
  {
    'stevearc/overseer.nvim',
    cmd = {
      "OverseerBuild", "OverseerClearCache", "OverseerClose",
      "OverseerDeleteBundle", "OverseerInfo", "OverseerLoadBundle",
      "OverseerOpen", "OverseerQuickAction", "OverseerRun",
      "OverseerRunCmd", "OverseerSaveBundle", "OverseerTaskAction",
      "OverseerToggle",
    },
    keys = {
      { '<Leader>or', '<Cmd>OverseerRun<CR> | <Cmd>OverseerOpen<CR>', desc = 'Overseer run task' },
      { '<Leader>ot', '<Cmd>OverseerToggle<CR>', desc = 'Overseer toggle task runner' },
      { '<Leader>oo', '<Cmd>OverseerOpen<CR>', desc = 'Overseer open task runner' },
    },
    opts = {},
  },
  {
    -- TODO: use templates for notes
    -- TODO: create keymaps
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    event = {
      "BufReadPre **/git/second-brain/*.md",
      "BufNewFile **/git/second-brain/*.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      daily_notes = {
        folder = "journal/daily",
        date_format = "%Y-%m-%d",
      },
      note_id_func = function(title)
        return title
      end,
      disable_frontmatter = true,
      workspaces = {
        {
          name = "second-brain",
          path = "~/git/second-brain",
        },
      },
      ui = {
        enable = false,
        checkboxes = {
          [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          ["x"] = { char = "✔", hl_group = "ObsidianDone" },
        },
      },
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<C-]>"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<CR>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
        ["<C-W>f"] = {
          action = function()
            local util = require("obsidian").util
            if util.cursor_on_markdown_link(nil, nil, true) then
              return "<cmd>ObsidianFollowLink hsplit<CR>"
            else
              return "<C-W>f"
            end
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
      },
      wiki_link_func = 'use_alias_only',
      callbacks = {
        pre_write_note = function(client, note)
          if not note:exists() then
            client:today():save({
              insert_frontmatter = false,
              update_content = function(lines)
                table.insert(lines, client:format_link(note))
                return lines
              end,
            })
          end
        end,
      },
    },
  }
  -- TODO: session plugin - https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#session
  -- TODO: neovim-project - https://github.com/coffebar/neovim-project
  -- TODO: nvim-highlight-color over mini.hipatterns - https://github.com/brenoprata10/nvim-highlight-colors
}
