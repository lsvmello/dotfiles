return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  version = "1.*", -- use a release tag to download pre-built binaries
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    keymap = {
      preset = "none",
      ["<C-Space>"] = { "show", "fallback" },
      ["<C-I>"] = { "show", "fallback" },
      ["<C-E>"] = { "cancel", "fallback" },
      ["<C-Y>"] = { "select_and_accept" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-P>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-N>"] = { "select_next", "fallback_to_mappings" },

      ["<C-L>"] = { "show_documentation", "fallback_to_mappings" },
      ["<C-H>"] = { "hide_documentation", "fallback_to_mappings" },
      ["<C-B>"] = { "scroll_documentation_up", "fallback" },
      ["<C-F>"] = { "scroll_documentation_down", "fallback" },

      ["<C-K>"] = { "show_signature", "hide_signature", "fallback" },
    },
    appearance = { nerd_font_variant = "normal" },
    completion = {
      ghost_text = { enabled = true },
      trigger = {
        prefetch_on_insert = false,
        show_in_snippet = false,
        show_on_keyword = false,
        show_on_trigger_character = false,
      },
      documentation = { auto_show = false },
    },
    cmdline = { enabled = false },
    signature = { enabled = true },
    sources = {
      -- Disable some sources in comments and strings.
      default = function()
        local sources = { 'lsp', 'buffer' }
        local ok, node = pcall(vim.treesitter.get_node)

        if ok and node then
          local node_type = node:type()
          if not vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node_type) then
            table.insert(sources, 'path')
          end
          if node_type ~= 'string' then
            table.insert(sources, 'snippets')
          end
        end

        return sources
      end,
    },
  },
  config = function(_, opts)
    local blink = require("blink.cmp")
    blink.setup(opts)

    vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities(nil, true) })
  end,
}
