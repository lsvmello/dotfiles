return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local themes = require("telescope.themes")
    telescope.setup({
      defaults = themes.get_ivy({
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim",
          "--hidden",
          "--glob",
          "!**/.git/*",
        },
        mappings = {
          i = {
            ["<C-s>"] = actions.select_horizontal,
            ["<C-c>"] = actions.close,
          },
          n = {
            ["<C-c>"] = actions.close,
            ["<C-s>"] = actions.select_horizontal,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
          },
        },
      }),
      extensions = {
        fzf = {},
      },
    })
    telescope.load_extension("fzf")
  end,
  keys = {
    -- quick keymaps
    { "<Leader>/", "<Cmd>Telescope live_grep<CR>", desc = "Live grep search" },
    { "<Leader>:", "<Cmd>Telescope command_history<CR>", desc = "Command history search" },
    { "<Leader><Leader>", "<Cmd>Telescope oldfiles<CR>", desc = "Find old files" },
    { "<Leader><Space>", "<Cmd>Telescope resume<CR>", desc = "Resume search" },
    { "<LocalLeader>/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Current buffer fuzzy search" },
    -- f keymaps
    { "<Leader>f<Space>", ":Telescope ", desc = "Telescope command" },
    { "<Leader>fa", "<Cmd>Telescope autocommands<CR>", desc = "Find autocommands" },
    { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
    {
      "<Leader>fb",
      "<Cmd>Telescope buffers initial_mode=normal sort_lastused=true sort_mru=true<CR>",
      desc = "Find buffers",
    },
    {
      "<Leader>fc",
      function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.stdpath("config"),
          prompt_title = "Find config files",
          hidden = true,
        })
      end,
      desc = "Find config files",
    },
    {
      "<Leader>fC",
      function()
        require("telescope.builtin").live_grep({
          cwd = vim.fn.stdpath("config"),
          prompt_title = "Live grep in config files",
          hidden = true,
        })
      end,
      desc = "Find in config files",
    },
    { "<Leader>fd", "<Cmd>Telescope diagnostics<CR>", desc = "Find diagnostics" },
    { "<Leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Find by grep" },
    { "<Leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Find help tags" },
    { "<Leader>fH", "<Cmd>Telescope highlights theme=dropdown<CR>", desc = "Find highlights" },
    { "<Leader>fk", "<Cmd>Telescope keymaps<CR>", desc = "Find keymaps" },
    { "<Leader>fo", "<Cmd>Telescope vim_options theme=dropdown<CR>", desc = "Find options" },
    { "<Leader>fr", "<Cmd>Telescope lsp_references<CR>", desc = "Find references" },
    { "<Leader>fR", "<Cmd>Telescope registers<CR>", desc = "Find Registers" },
    { "<Leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Find symbols in document" },
    { "<Leader>fS", "<Cmd>Telescope lsp_workspace_symbols<CR>", desc = "Find symbols in workspace" },
    { "<Leader>fw", "<Cmd>Telescope grep_string<CR>", mode = { "n", "v" }, desc = "Find word" },
    -- g keymaps
    { "<Leader>gb", "<Cmd>Telescope git_branches<CR>", desc = "Find branches" },
    { "<Leader>gc", "<Cmd>Telescope git_commits<CR>", desc = "Find commits" },
    { "<LocalLeader>gc", "<Cmd>Telescope git_bcommits<CR>", desc = "Find commits of current buffer" },
    { "<LocalLeader>gc", "<Cmd>Telescope git_bcommits_range<CR>", mode = "v", desc = "Find commit of current range" },
    { "<Leader>gS", "<Cmd>Telescope git_stash<CR>", desc = "Find stashes" },
    -- others
    {
      "<Leader>fp",
      function()
        require("telescope.builtin").find_files({
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
          prompt = "Find in plugins",
        })
      end,
      desc = "Find in packages",
    },
    {
      "<Leader>fn",
      function()
        require("telescope.builtin").find_files({ cwd = vim.env.VIMRUNTIME, prompt = "Find in Neovim" })
      end,
      desc = "Find in Neovim runtime files",
    },
  },
}
