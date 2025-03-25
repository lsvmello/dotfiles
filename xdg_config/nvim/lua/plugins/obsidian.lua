return {
  "epwalsh/obsidian.nvim",
  event = {
    "BufReadPre **/git/second-brain/*.md",
    "BufNewFile **/git/second-brain/*.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = {
    "ObsidianOpen", "ObsidianNew", "ObsidianQuickSwitch",
    "ObsidianFollowLink", "ObsidianBacklinks", "ObsidianTags",
    "ObsidianToday", "ObsidianYesterday", "ObsidianTomorrow",
    "ObsidianDailies", "ObsidianTemplate", "ObsidianSearch",
    "ObsidianLink", "ObsidianLinkNew", "ObsidianLinks",
    "ObsidianExtractNote", "ObsidianWorkspace", "ObsidianPasteImg",
    "ObsidianRename", "ObsidianToggleCheckbox", "ObsidianNewFromTemplate",
    "ObsidianTOC",
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
    wiki_link_func = "use_alias_only",
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
  keys = {
    {
      "<Leader>n",
      function()
        vim.cmd.tabnew("~/git/second-brain/")
      end,
      desc = "Open Notes",
    },
    { "<Leader>fn", "<Cmd>ObsidianSearch<CR>", desc = "Find in Notes" },
  },
}
