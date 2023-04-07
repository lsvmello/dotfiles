local find_files = function()
  return function()
    local ok = pcall(require("telescope.builtin").git_files, { show_untracked = true })
    if not ok then
      require("telescope.builtin").find_files()
    end
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- use HEAD
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          -- stylua: ignore
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading",
            "--with-filename", "--line-number",
            "--column", "--smart-case", "--trim",
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
      -- quick keymaps
      { "<Leader><Leader>", "<Cmd>Telescope resume<CR>", desc = "Telescope Resume" },
      { "<Leader>/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Find in Files (Grep)" },
      { "<Leader>:", "<Cmd>Telescope command_history<CR>", desc = "Command History" },
      { "<Leader><Space>", find_files(), desc = "Find Files" },
      -- f keymaps
      { "<Leader>fM", "<Cmd>Telescope man_pages<CR>", desc = "[F]ind [M]an Pages" },
      { "<Leader>fr", "<Cmd>Telescope oldfiles<CR>", desc = "[F]ind [R]ecent Files" },
      { "<Leader>fb", "<Cmd>Telescope buffers show_all_buffers=true<CR>", desc = "[F]ind [B]uffers" },
      { "<Leader>fc", "<Cmd>Telescope command_history<CR>", desc = "[F]ind [C]ommand History" },
      { "<Leader>fd", "<Cmd>Telescope diagnostics<CR>", desc = "[F]ind [D]iagnostics" },
      { "<Leader>ff", "<Cmd>Telescope files<CR>", desc = "[F]ind [F]iles" },
      { "<Leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "[F]ind by [G]rep" },
      { "<Leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "[F]ind [H]elp Tags" },
      { "<Leader>fk", "<Cmd>Telescope keymaps<CR>", desc = "[F]ind [K]eymaps" },
      { "<Leader>fo", "<Cmd>Telescope vim_options<CR>", desc = "[F]ind [O]ptions" },
      { "<Leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "[F]ind Document [S]ymbols", },
      { "<Leader>fS", "<Cmd>Telescope lsp_workspace_symbols<CR>", desc = "[F]ind Document [S]ymbols", },
      { "<Leader>ft", "<Cmd>Telescope builtin<CR>", desc = "[F]ind [T]elescope" },
      { "<Leader>fw", "<Cmd>Telescope grep_string<CR>", mode = { "n", "v" }, desc = "[F]ind [W]ord" },
    },
  },
}
