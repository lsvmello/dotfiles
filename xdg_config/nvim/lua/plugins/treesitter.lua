return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = "BufReadPost",
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    opts = {
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      -- stylua: ignore
      ensure_installed = {
        "bash", "c", "cpp", "diff", "go",
        "help", "javascript", "json", "lua",
        "markdown", "markdown_inline", "python",
        "query", "regex", "rust", "toml", "typescript",
        "vim", "yaml",
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = { ["<leader>a"] = "@parameter.inner" },
          swap_previous = { ["<leader>A"] = "@parameter.inner" },
        },
      },
    },
  },
  "nvim-treesitter/nvim-treesitter-textobjects",
  "nvim-treesitter/playground",
  "JoosepAlviste/nvim-ts-context-commentstring",
}
