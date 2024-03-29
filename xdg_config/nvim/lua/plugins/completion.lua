return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
      "LuaSnip", -- already configured
    },
    opts = function()
      local cmp = require("cmp")
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-B>"] = cmp.mapping.scroll_docs(-4),
          ["<C-F>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-E>"] = cmp.mapping.abort(),
          ["<C-Y>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("lsvmello.icons").kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            h1_group = "LspCodeLens",
          },
        },
      }
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function(_, opts)
      local luasnip = require("luasnip")
      luasnip.setup(opts)
      require("luasnip.loaders.from_vscode").lazy_load()

      vim.keymap.set({"i", "s"}, "<Tab>", function()
        if luasnip.expand_or_locally_jumpable() then luasnip.jump(1)
        else return "<Tab>" end
      end, { expr = true })
      vim.keymap.set({"i", "s"}, "<S-Tab>", function()
        if luasnip.locally_jumpable(-1) then luasnip.jump(-1)
        else return "<S-Tab>" end
      end, { expr = true })
    end,
  },
  {
    "github/copilot.vim",
    cmd = "Copilot",
    dependencies = { "LuaSnip"}, -- load after <Tab> has been remapped
  },
}
