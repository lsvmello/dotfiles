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
          -- stylua: ignore
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading",
            "--with-filename", "--line-number",
            "--column", "--smart-case", "--trim",
          },
          mappings = {
            i = { ["<Esc>"] = actions.close },
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
    keys = function()
      local function find_files()
        local ok = pcall(require("telescope.builtin").git_files, { show_untracked = true })
        if not ok then
          require("telescope.builtin").find_files()
        end
      end

      return {
      -- quick keymaps
      { "<Leader>/", "<Cmd>Telescope live_grep<CR>", desc = "Search by Grep" },
      { "<Leader>:", "<Cmd>Telescope command_history<CR>", desc = "Search Command History" },
      { "<Leader><Space>", find_files, desc = "Search Files" },
      -- f keymaps
      { "<Leader>f", "<Cmd>Telescope resume<CR>", desc = "Resume Search" },
      { "<Leader>fb", "<Cmd>Telescope buffers show_all_buffers=true<CR>", desc = "[F]ind [B]uffers" },
      { "<Leader>fd", "<Cmd>Telescope diagnostics<CR>", desc = "[F]ind [D]iagnostics" },
      { "<Leader>ff", find_files, desc = "[F]ind [F]iles" },
      { "<Leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "[F]ind by [G]rep" },
      { "<Leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "[F]ind [H]elp Tags" },
      { "<Leader>fk", "<Cmd>Telescope keymaps<CR>", desc = "[F]ind [K]eymaps" },
      { "<Leader>fo", "<Cmd>Telescope oldfiles<CR>", desc = "[F]ind [O]ld Files" },
      { "<Leader>fO", "<Cmd>Telescope vim_options<CR>", desc = "[F]ind [O]ptions" },
      { "<Leader>fr", "<Cmd>Telescope lsp_references<CR>", desc = "[F]ind [R]eferences" },
      { "<Leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "[F]ind Document [S]ymbols" },
      { "<Leader>fS", "<Cmd>Telescope lsp_workspace_symbols<CR>", desc = "[F]ind Workspace [S]ymbols" },
      { "<Leader>ft", "<Cmd>Telescope builtin<CR>", desc = "[F]ind [T]elescope" },
      { "<Leader>fw", "<Cmd>Telescope grep_string<CR>", mode = { "n", "v" }, desc = "[F]ind [W]ord" },
    }
    end,
  },
}
