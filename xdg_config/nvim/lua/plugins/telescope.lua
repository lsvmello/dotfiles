local telescope_builtin = function(builtin, opts)
  return function()
    require("telescope.builtin")[builtin](opts)
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          winblend = 10,
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim",
          },
          mappings = {
            i = {
              ["<esc>"] = actions.close,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
    -- stylua: ignore
    keys = {
      { "<leader>?", telescope_builtin("oldfiles"), desc = "[?] Find recently opened files" },
      { "<leader><space>", telescope_builtin("buffers"), desc = "[ ] Find existing buffers" },
      { "<leader>/", telescope_builtin( "current_buffer_fuzzy_find"), desc = "[/] Fuzzily search in current buffer]" },
      { "<leader>fc", telescope_builtin("command_history"), desc = "[F]ind [C]ommand History" },
      { "<leader>fd", telescope_builtin("diagnostics"), desc = "[F]ind [D]iagnostics" },
      { "<leader>ff", telescope_builtin("find_files"), desc = "[F]ind [F]iles" },
      { "<leader>fg", telescope_builtin("live_grep"), desc = "[F]ind by [G]rep" },
      { "<leader>fgc", telescope_builtin("git_commits"), desc = "[F]ind [G]it [C]ommits" },
      { "<leader>fh", telescope_builtin("help_tags"), desc = "[F]ind [H]elp Tags" },
      { "<leader>fk", telescope_builtin("keymaps"), desc = "[F]ind [K]eymaps" },
      { "<leader>ft", telescope_builtin("builtin"), desc = "[F]ind [T]elescope" },
      { "<leader>fw", telescope_builtin("grep_string"), desc = "[F]ind current [W]ord" },
    },
  },
}
