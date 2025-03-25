return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "http" })
    end,
  },
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    opts = {
      vscode_rest_client_environmentvars = true,
      treesitter = true,
    },
    keys = {
      { "[[", '<Cmd>lua require("kulala").jump_prev()<CR>', desc = "Jump to the next request", ft = "http" },
      { "]]", '<Cmd>lua require("kulala").jump_next()<CR>', desc = "Jump to the previous request", ft = "http" },
      { "<CR>", '<Cmd>lua require("kulala").run()<CR>', desc = "Execute the request", ft = "http" },
      { "<LocalLeader>ci", '<Cmd>lua require("kulala").from_curl()<CR>', desc = "Paste curl from clipboard as request", ft = "http" },
      {"<LocalLeader>co", '<Cmd>lua require("kulala").copy()<CR>', desc = "Copy the current request as a curl command", ft = "http" },
      {"<LocalLeader>e", '<Cmd>lua require("kulala").set_selected_env()<CR>', desc = "Set environment", ft = "http" },
      {"<LocalLeader>i", '<Cmd>lua require("kulala").inspect()<CR>', desc = "Inspect the current request", ft = "http" },
      {"<LocalLeader>q", '<Cmd>lua require("kulala").close()<CR>', desc = "Close request", ft = "http" },
      {"<LocalLeader>v", '<Cmd>lua require("kulala").toggle_view()<CR>', desc = "Toggle view between body and header", ft = "http" },
    },
  },
}
