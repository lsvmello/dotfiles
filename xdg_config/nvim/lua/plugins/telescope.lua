return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
        defaults = {
          -- stylua: ignore
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading",
            "--with-filename", "--line-number",
            "--column", "--smart-case", "--trim",
            "--hidden", "--glob", "!**/.git/*",
          },
          mappings = {
            i = {
              ["<C-s>"] = actions.select_horizontal,
              ["<C-c>"] = actions.close,
            },
            n = {
              ["<C-s>"] = actions.select_horizontal,
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "ivy",
          },
        },
        extensions = {
          fzf = {},
        },
      })
      telescope.load_extension("fzf")
    end,
    -- stylua: ignore
    keys = {
      -- quick keymaps
      { "<Leader>/", "<Cmd>Telescope live_grep<CR>", desc = "Live Grep Search" },
      { "<Leader>:", "<Cmd>Telescope command_history<CR>", desc = "Command History Search" },
      { "<Leader><Leader>", "<Cmd>Telescope oldfiles theme=ivy<CR>", desc = "Find old files" },
      { "<Leader><Space>", "<Cmd>Telescope resume<CR>", desc = "Resume Search" },
      { "<LocalLeader>/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Current buffer fuzzy search" },
      -- f keymaps
      { "<Leader>f<Space>", ":Telescope ", desc = "Telescope command" },
      { "<Leader>fa", "<Cmd>Telescope autocommands<CR>", desc = "Find autocommands" },
      { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<Leader>fb", "<Cmd>Telescope buffers initial_mode=normal sort_lastused=true sort_mru=true theme=ivy<CR>", desc = "Find buffers" },
      { "<Leader>fc", function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config"), prompt_title = "Find Config Files" }) end, desc = "Find config Files" },
      { "<Leader>fC", function() require("telescope.builtin").live_grep({ cwd = vim.fn.stdpath("config"), prompt_title = "Live Grep on Config Files" }) end, desc = "Find in config Files" },
      { "<Leader>fd", "<Cmd>Telescope diagnostics<CR>", desc = "Find diagnostics" },
      { "<Leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Find by grep" },
      { "<Leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Find help tags" },
      { "<Leader>fH", "<Cmd>Telescope highlights theme=dropdown<CR>", desc = "Find highlights" },
      { "<Leader>fk", "<Cmd>Telescope keymaps<CR>", desc = "Find keymaps" },
      { "<Leader>fo", "<Cmd>Telescope vim_options theme=dropdown<CR>", desc = "Find options" },
      { "<Leader>fr", "<Cmd>Telescope lsp_references<CR>", desc = "Find references" },
      { "<Leader>fR", "<Cmd>Telescope registers<CR>", desc = "Find Registers" },
      { "<Leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Find symbols in document" },
      { "<Leader>fS", "<Cmd>Telescope lsp_workspace_symbols<CR>", desc = "Find Symbols in workspace" },
      { "<Leader>fw", "<Cmd>Telescope grep_string<CR>", mode = { "n", "v" }, desc = "Find word" },
      -- g keymaps
      { "<Leader>gb", "<Cmd>Telescope git_branches<CR>", desc = "Find branches" },
      { "<Leader>gc", "<Cmd>Telescope git_commits<CR>", desc = "Find commits" },
      { "<LocalLeader>gc", "<Cmd>Telescope git_bcommits<CR>", desc = "Find commits of current buffer" },
      { "<LocalLeader>gc", "<Cmd>Telescope git_bcommits_range<CR>", mode = "v", desc = "Find commit of current range" },
      { "<Leader>gS", "<Cmd>Telescope git_stash<CR>", desc = "Find stashes" },
      -- others
      { "<Leader>fp", function()
        require("telescope.builtin").find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"), theme = "ivy" })
      end, desc = "Find in packages" },
    },
  },
}
