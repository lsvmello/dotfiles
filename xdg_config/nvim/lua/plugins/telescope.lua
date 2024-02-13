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
      { "<Leader>fb", "<Cmd>Telescope buffers show_all_buffers=true<CR>", desc = "Find buffers" },
      { "<Leader>fd", "<Cmd>Telescope diagnostics<CR>", desc = "Find diagnostics" },
      { "<Leader>ff", find_files, desc = "Find files" },
      { "<Leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Find by grep" },
      { "<Leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Find help tags" },
      { "<Leader>fk", "<Cmd>Telescope keymaps<CR>", desc = "Find keymaps" },
      { "<Leader>fo", "<Cmd>Telescope oldfiles<CR>", desc = "Find old files" },
      { "<Leader>fO", "<Cmd>Telescope vim_options<CR>", desc = "Find options" },
      { "<Leader>fr", "<Cmd>Telescope lsp_references<CR>", desc = "Find references" },
      { "<Leader>fR", "<Cmd>Telescope registers<CR>", desc = "Find registers" },
      { "<Leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Find document symbols" },
      { "<Leader>fS", "<Cmd>Telescope lsp_workspace_symbols<CR>", desc = "Find workspace symbols" },
      { "<Leader>ft", "<Cmd>Telescope builtin<CR>", desc = "Find Telescope" },
      { "<Leader>fw", "<Cmd>Telescope grep_string<CR>", mode = { "n", "v" }, desc = "Find word" },
    }
    end,
  },
}
