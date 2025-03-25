return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "git_config", "gitcommit", "git_rebase",
        "gitignore", "gitattributes",
      })
    end,
  },
}
