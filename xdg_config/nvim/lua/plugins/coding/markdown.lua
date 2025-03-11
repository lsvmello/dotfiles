return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'markdown', 'markdown_inline' }
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter' },
    ft = 'markdown',
    opts = {
      latex = {
        enabled = false,
      },
      heading = {
        width = 'block',
      },
      checkbox = {
        position = 'overlay',
        custom = {
          stroke = { raw = '[-]', rendered = '󰛲 ', scope_highlight = '@markup.strikethrough' },
        },
      },
      code = {
        style = 'normal',
        border = 'thin',
        width = 'block',
        left_pad = 2,
        right_pad = 2,
      },
      sign = {
        enabled = false,
      },
    },
  },
}
