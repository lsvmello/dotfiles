-- select all
vim.keymap.set({ 'n', 'v', 'i' }, '<M-a>', '<Esc>ggVG$', { desc = 'Select All' })

-- Powerful <Esc>
vim.keymap.set({ 'n', 'v', 'i' }, '<Esc>', function()
  vim.cmd.nohlsearch()
  vim.snippet.stop()
  return '<Esc>'
end, { desc = 'Escape, clear hlsearch and stop snippet session', expr = true })

-- scroll with arrows
vim.keymap.set('n', '<Up>', '<C-Y>', { desc = 'Scroll up' })
vim.keymap.set('n', '<Down>', '<C-E>', { desc = 'Scroll down' })

-- resize window using arrow keys
vim.keymap.set('n', '<C-=>', '<C-W>3+', { desc = 'Increase window height' })
vim.keymap.set('n', '<M-=>', '<C-W>3>', { desc = 'Increase window width' })
vim.keymap.set('n', '<C-->', '<C-W>3-', { desc = 'Decrease window height' })
vim.keymap.set('n', '<M-->', '<C-W>3<', { desc = 'Decrease window width' })

-- move lines
vim.keymap.set('n', '<M-j>', [[:move .+1<CR>==]], { silent = true, desc = 'Move line down' })
vim.keymap.set('v', '<M-j>', [[:move '>+1<CR>gv=gv]], { silent = true, desc = 'Move lines down' })
vim.keymap.set('i', '<M-j>', [[<Esc>:move .+1<CR>==gi]], { silent = true, desc = 'Move line down' })
vim.keymap.set('n', '<M-k>', [[:move .-2<CR>==]], { silent = true, desc = 'Move line up' })
vim.keymap.set('v', '<M-k>', [[:move '<-2<CR>gv=gv]], { silent = true, desc = 'Move lines up' })
vim.keymap.set('i', '<M-k>', [[<Esc>:move .-2<CR>==gi]], { silent = true, desc = 'Move line up' })

-- better navigation
vim.keymap.set('n', 'j', 'v:count ? "j" :"gj"', { expr = true })
vim.keymap.set('n', 'k', 'v:count ? "k" : "gk"', { expr = true })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines' })
vim.keymap.set('n', '<C-D>', '<C-D>zz', { desc = 'Scroll half page down' })
vim.keymap.set('n', '<C-U>', '<C-U>zz', { desc = 'Scroll half page up' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result' })

-- indentation
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '<', '<gv')

-- better copy and paste
vim.keymap.set({ 'n', 'v' }, '<LocalLeader>p', [["0p]], { desc = 'Put last yanked text after the cursor [count] times' })
vim.keymap.set({ 'n', 'v' }, '<LocalLeader>P', [["0P]], { desc = 'Put last yanked text before the cursor [count] times' })
vim.keymap.set({ 'n', 'v' }, '<Leader>P', [["+p]], { desc = 'Put from clipboard after the cursor [count] times' })
vim.keymap.set({ 'n', 'v' }, '<Leader>P', [["+P]], { desc = 'Put from clipboard before the cursor [count] times' })
vim.keymap.set({ 'n', 'v' }, '<Leader>y', [["+y]], { desc = 'Yank {motion} text into the clipboard' })
vim.keymap.set({ 'n', 'v' }, '<Leader>y', [["+y]], { desc = 'Yank [count] lines into the clipboard' })

-- subistitute
vim.keymap.set('n', '<LocalLeader>s', '"syiw:%s/<C-r>s//gc<Left><Left><Left>', { desc = 'Substitute word' })
vim.keymap.set('v', '<LocalLeader>s', '"sy<Esc>:%s/\\V<C-r>s//gc<Left><Left><Left>', { desc = 'Substitute selection' })

-- duplicate lines
vim.keymap.set('n', '<LocalLeader>j', function()
  if vim.v.count > 1 then -- consider count and move the cursor to the first copied line
    return string.format(':.,.+%st+%s<CR>%sk', vim.v.count, vim.v.count - 1, vim.v.count - 1)
  end
  return ':t.<CR>'
end, { expr = true, silent = true, desc = 'Duplicate [count] lines' })
vim.keymap.set('v', '<LocalLeader>j', function()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local vis_line = vim.fn.line('v')
  local count = vim.fn.abs(cur_line - vis_line)
  if count > 0 then   -- consider multiple lines and move the cursor to the first copied line
    return string.format(':t+%s<CR>%sk', count, count)
  end
  return string.format(':t+%s<CR>', count)
end, { expr = true, silent = true, desc = 'Duplicate selected lines' })
-- duplicate and comment lines
vim.keymap.set('n', '<LocalLeader>J', function()
  if vim.v.count > 1 then
    return ':.,.+' .. vim.v.count - 1 .. 't-1<CR>:norm gc' .. vim.v.count - 1 .. 'k<CR>' .. vim.v.count .. 'j'
  end
  return ':t-1<CR>:norm gc$<CR>j'
end, { expr = true, silent = true, desc = 'Duplicate and comment [count] lines' })

vim.keymap.set('v', '<LocalLeader>J', function()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local vis_line = vim.fn.line('v')
  local count = vim.fn.abs(cur_line - vis_line)
  return ':t-1<CR>:norm gc' .. count .. 'k<CR>' .. count + 1 .. 'j'
end, { expr = true, silent = true, desc = 'Duplicate and comment selected lines' })

-- diagnostic error navigations
vim.keymap.set({ 'n', 'x', 'o' }, '[e',
  function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR }) end,
  { desc = 'Jump to previous error' })
vim.keymap.set({ 'n', 'x', 'o' }, ']e',
  function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end,
  { desc = 'Jump to next error' })

-- close quickfix and location lists
vim.keymap.set('n', '<C-Q>', function()
  vim.cmd.cclose()
  vim.cmd.lclose()
end, { desc = 'Close quickfix/location list' })

-- add undo break-points
for _, char in ipairs({ ',', '.', ';' }) do
  vim.keymap.set('i', char, char .. '<C-G>u')
end

-- ABNT keyboard fix
for _, char in ipairs({ '~', '^', '`', '´' }) do
  vim.keymap.set({ '', '!', 'l', 't' }, char .. char, char)
end

-- terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-N>', { desc = 'go to Normal mode' })
vim.keymap.set('t', '<C-C><C-C>', '<C-\\><C-N>', { desc = 'go to Normal mode' })
vim.keymap.set('t', '<C-\\><C-R>', function()
  -- TODO: add extmark
  return '<C-\\><C-N>"' .. vim.fn.nr2char(vim.fn.getchar()) .. 'pi'
end, { desc = 'insert the contents of a numbered or named register', expr = true })

vim.keymap.set('t', '<C-L>', function()
  vim.fn.feedkeys('', 'n')
  local sb = vim.bo.scrollback
  vim.bo.scrollback = 1
  vim.bo.scrollback = sb
end, { desc = 'clear terminal scrollback' })
