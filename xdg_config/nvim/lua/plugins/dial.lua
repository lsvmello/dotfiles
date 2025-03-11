return {
  'monaqa/dial.nvim',
  cond = false,
  keys = {
    { '<C-A>',  '<Plug>(dial-increment)', mode = { 'n', 'v' }, desc = 'Dial increment' },
    { '<C-X>',  '<Plug>(dial-decrement)', mode = { 'n', 'v' }, desc = 'Dial decrement' },
    { 'g<C-A>', 'g<Plug>(dial-increment)', mode = { 'n', 'v' }, remap = true, desc = 'Dial smart increment' },
    { 'g<C-X>', 'g<Plug>(dial-decrement)', mode = { 'n', 'v' }, remap = true, desc = 'Dial smart decrement' },
  },
  config = function()
    local augend = require('dial.augend')
    require('dial.config').augends:register_group({
      default = {
        augend.constant.alias.bool,
        augend.constant.new({ elements = { 'and', 'or' }, word = true, cyclic = true }),
        augend.constant.new({ elements = { '&&', '||' }, word = false, cyclic = true }),
        augend.constant.new({ elements = { 'no', 'yes' }, word = true, cyclic = true }),
        augend.constant.new({ elements = { 'on', 'off' }, word = true, cyclic = true }),
        augend.date.alias['%m/%d'],
        augend.date.alias['%-m/%-d'],
        augend.date.alias['%H:%M'],
        augend.date.alias['%H:%M:%S'],
        augend.date.alias['%Y-%m-%d'],
        augend.date.alias['%Y/%m/%d'],
        augend.decimal_fraction.new({ signed = true }),
        augend.integer.alias.binary,
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,
        augend.integer.alias.octal,
        augend.semver.alias.semver,
      },
    })
  end,
}
