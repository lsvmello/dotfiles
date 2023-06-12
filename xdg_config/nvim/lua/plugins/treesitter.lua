return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = "BufReadPost",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter-textobjects", -- configured below
      { "nvim-treesitter/nvim-treesitter-context", config = true },
    },
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
      context_commentstring = {
        enable = true,
      },
      -- stylua: ignore
      ensure_installed = {
        "bash", "c", "cpp", "diff", "fish",
        "gitcommit", "gitignore", "git_rebase",
        "go", "javascript", "json", "lua",
        "markdown", "markdown_inline", "python",
        "query", "regex", "rust", "toml",
        "typescript", "vim", "vimdoc", "yaml",
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["a/"] = { query = "@comment.outer", desc = "Select outer part of a comment" },
            ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter" },
            ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
            ["af"] = { query = "@function.outer", desc = "Select outer part of a function" },
            ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
            ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
            ["am"] = { query = "@function.outer", desc = "Select outer part of a method" },
            ["ar"] = { query = "@return.outer", desc = "Select outer part of a return" },
            ["as"] = { query = "@scope", query_group = "locals", desc = "Select outer part of a scope" },
            ["az"] = { query = "@fold.outer", query_group = "folds", desc = "Select outer part of a fold" },
            ["i/"] = { query = "@comment.inner", desc = "Select inner part of a comment" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter" },
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
            ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
            ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
            ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
            ["im"] = { query = "@function.inner", desc = "Select inner part of a method" },
            ["ir"] = { query = "@return.inner", desc = "Select inner part of a return" },
            ["is"] = { query = "@scope", query_group = "locals", desc = "Select inner part of a scope" },
            ["iz"] = { query = "@fold.inner", query_group = "folds", desc = "Select inner part of a fold" },
          },
        },
        swap = {
          enable = true,
          swap_next = { ["<LocalLeader>a"] = "@parameter.inner" },
          swap_previous = { ["<LocalLeader>A"] = "@parameter.inner" },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]/"] = { query = "@comment.outer", desc = "Next Comment" },
            ["]C"] = { query = "@class.outer", desc = "Next Class" },
            ["]L"] = { query = "@loop.outer", desc = "Next Loop" },
            ["]f"] = { query = "@function.outer", desc = "Next Function" },
            ["]i"] = { query = "@conditional.inner", desc = "Next Conditional" },
            ["]m"] = { query = "@function.outer", desc = "Next Method" },
            ["]r"] = { query = "@return.inner", desc = "Next Return" },
            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next Scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next Fold" },
          },
          goto_previous_start = {
            ["[/"] = { query = "@comment.outer", desc = "Next Comment" },
            ["[C"] = { query = "@class.outer", desc = "Previous Class" },
            ["[L"] = { query = "@loop.outer", desc = "Previous Loop" },
            ["[f"] = { query = "@function.outer", desc = "Previous Function" },
            ["[i"] = { query = "@conditional.inner", desc = "Previous Conditional" },
            ["[m"] = { query = "@function.outer", desc = "Previous Method" },
            ["[r"] = { query = "@return.inner", desc = "Previous Return" },
            ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous Scope" },
            ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous Fold" },
          },
        },
        lsp_interop = {
          enable = true,
          peek_definition_code = {
            ["<LocalLeader>K"] = "@function.outer",
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true, -- only load as dependency
    dependencies = {
      "gitsigns.nvim",
    },
    config = function()
      local map = function(lhs, rhs, opts)
        opts = opts or {}
        vim.keymap.set({ "n", "x", "o" }, lhs, rhs, opts)
      end
      local repeatable = require("nvim-treesitter.textobjects.repeatable_move")

      -- stylua: ignore start
      map(";", repeatable.repeat_last_move, { desc = "Repeat lastest f, t, F, T or custom movement" })
      map(",", repeatable.repeat_last_move_opposite, { desc = "Repeat lastest f, t, F, T or custom movement in opposite direction" })
      map("f", repeatable.builtin_f, { desc = "To [count]'th occurence of {char} to the right" })
      map("F", repeatable.builtin_F, { desc = "To [count]'th occurence of {char} to the left" })
      map("t", repeatable.builtin_t, { desc = "Till before [count]'th occurence of {char} to the right" })
      map("T", repeatable.builtin_T, { desc = "Till after [count]'th occurence of {char} to the left" })

      local next_hunk, prev_hunk = repeatable.make_repeatable_move_pair(function()
        if vim.wo.diff then return "]c" end
        vim.schedule(require("gitsigns").next_hunk)
        return "<Ignore>"
      end, function()
        if vim.wo.diff then return "[c" end
        vim.schedule(require("gitsigns").prev_hunk)
        return "<Ignore>"
      end)
      map("]c", next_hunk, { desc = "Jump forward to the next start of a change", expr = true })
      map("[c", prev_hunk, { desc = "Jump backwards to the previous start of a change", expr = true })

      local next_quickfix, prev_quickfix = repeatable.make_repeatable_move_pair(vim.cmd.cprevious, vim.cmd.cnext)
      map("]q", next_quickfix, { desc = "Next Quickfix item" })
      map("[q", prev_quickfix, { desc = "Previous Quickfix item" })
      local next_locationlist, prev_locationlist = repeatable.make_repeatable_move_pair(vim.cmd.lprevious, vim.cmd.lnext)

      map("]l", next_locationlist, { desc = "Next Location List item" })
      map("[l", prev_locationlist, { desc = "Previous Location List item" })

      local next_buffer, prev_buffer = repeatable.make_repeatable_move_pair(vim.cmd.bnext, vim.cmd.bprevious)
      map("]b", next_buffer, { desc = "Next Buffer" })
      map("[b", prev_buffer, { desc = "Previous Buffer" })

      local next_diagnostic, prev_diagnostic = repeatable.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
      map("]d", next_diagnostic, { desc = "Next Diagnostic" })
      map("[d", prev_diagnostic, { desc = "Previous Diagnostic" })
    end,
  },
}
