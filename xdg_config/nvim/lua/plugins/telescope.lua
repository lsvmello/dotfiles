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
    keys = {
      -- quick keymaps
      { "<Leader><Leader>", "<Cmd>Telescope resume<CR>", desc = "Resume Search" },
      { "<Leader>/", "<Cmd>Telescope live_grep<CR>", desc = "Search by Grep" },
      { "<Leader>:", "<Cmd>Telescope command_history<CR>", desc = "Search Command History" },
      { "<Leader><Space>", function()
        local ok = pcall(require("telescope.builtin").git_files, { show_untracked = true })
        if not ok then
          require("telescope.builtin").find_files()
        end
      end, desc = "Find Files" },
      -- f keymaps
      { "<Leader>b", "<Cmd>Telescope buffers show_all_buffers=true<CR>", desc = "Search [B]uffers" },
      { "<Leader>d", "<Cmd>Telescope diagnostics<CR>", desc = "Search [D]iagnostics" },
      { "<Leader>H", "<Cmd>Telescope help_tags<CR>", desc = "Search [H]elp Tags" },
      { "<Leader>k", "<Cmd>Telescope keymaps<CR>", desc = "Search [K]eymaps" },
      { "<Leader>o", "<Cmd>Telescope oldfiles<CR>", desc = "Search [O]ld Files" },
      { "<Leader>O", "<Cmd>Telescope vim_options<CR>", desc = "Search [O]ptions" },
      { "<Leader>r", "<Cmd>Telescope lsp_references<CR>", desc = "Search [R]eferences" },
      { "<Leader>s", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Search Document [S]ymbols" },
      { "<Leader>S", "<Cmd>Telescope lsp_workspace_symbols<CR>", desc = "Search Workspace [S]ymbols" },
      { "<Leader>t", "<Cmd>Telescope builtin<CR>", desc = "Search [T]elescope" },
      { "<Leader>w", "<Cmd>Telescope grep_string<CR>", mode = { "n", "v" }, desc = "Search [W]ord" },
    },
  },
}
