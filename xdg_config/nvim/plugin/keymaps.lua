local map = vim.keymap.set

-- select all
map({ "n", "v", "i" }, "<M-a>", "<Esc>ggVG$", { desc = "Select All" })

-- scroll with arrows
map("n", "<Up>", "<C-Y>", { desc = "Scroll up" })
map("n", "<Down>", "<C-E>", { desc = "Scroll down" })

-- resize window using arrow keys
map("n", "<C-=>", "<C-W>3+", { desc = "Increase window height" })
map("n", "<M-=>", "<C-W>3>", { desc = "Increase window width" })
map("n", "<C-->", "<C-W>3-", { desc = "Decrease window height" })
map("n", "<M-->", "<C-W>3<", { desc = "Decrease window width" })

-- move lines
map("n", "<M-j>", ":move .+1<CR>==", { silent = true, desc = "Move line down" })
map("v", "<M-j>", ":move '>+1<CR>gv=gv", { silent = true, desc = "Move lines down" })
map("i", "<M-j>", "<Esc>:move .+1<CR>==gi", { silent = true, desc = "Move line down" })
map("n", "<M-k>", ":move .-2<CR>==", { silent = true, desc = "Move line up" })
map("v", "<M-k>", ":move '<-2<CR>gv=gv", { silent = true, desc = "Move lines up" })
map("i", "<M-k>", "<Esc>:move .-2<CR>==gi", { silent = true, desc = "Move line up" })

-- better navigation
map("n", "j", function() return vim.v.count == 0 and "gj" or "j" end, { expr = true })
map("n", "k", function() return vim.v.count == 0 and "gk" or "k" end, { expr = true })
map("n", "J", "mzJ`z", { desc = "Join lines" })
map("n", "<C-D>", "<C-D>zz", { desc = "Scroll half page down" })
map("n", "<C-U>", "<C-U>zz", { desc = "Scroll half page up" })
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Previous search result" })

-- indentation
map("v", ">", ">gv")
map("v", "<", "<gv")

-- better copy and paste
map({ "n", "v" }, "<LocalLeader>p", [["0p]], { desc = "Put last yanked text after the cursor [count] times" })
map({ "n", "v" }, "<LocalLeader>P", [["0P]], { desc = "Put last yanked text before the cursor [count] times" })
map({ "n", "v" }, "<M-P>", [["+p]], { desc = "Put from clipboard after the cursor [count] times" })
map({ "n", "v" }, "<M-S-P>", [["+P]], { desc = "Put from clipboard before the cursor [count] times" })
map({ "n", "v" }, "<M-Y>", [["+y]], { desc = "Yank {motion} text into the clipboard" })
map({ "n", "v" }, "<M-S-Y>", [["+Y]], { desc = "Yank [count] lines into the clipboard" })

-- duplicate lines
map("n", "<LocalLeader>j", function()
  if vim.v.count > 1 then -- consider count and move the cursor to the first copied line
    return string.format(":.,.+%st+%s<CR>%sk", vim.v.count, vim.v.count - 1, vim.v.count - 1)
  end
  return ":t.<CR>"
end, { expr = true, silent = true, desc = "Duplicate [count] lines" })
map("v", "<LocalLeader>j", function()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local vis_line = vim.fn.line("v")
  local count = vim.fn.abs(cur_line - vis_line)
  if count > 0 then   -- consider multiple lines and move the cursor to the first copied line
    return string.format(":t+%s<CR>%sk", count, count)
  end
  return string.format(":t+%s<CR>", count)
end, { expr = true, silent = true, desc = "Duplicate selected lines" })
-- duplicate and comment lines
map("n", "<LocalLeader>J", function()
  if vim.v.count > 1 then
    return ":.,.+" .. vim.v.count - 1 .. "t-1<CR>:norm gc" .. vim.v.count - 1 .. "k<CR>" .. vim.v.count .. "j"
  end
  return ":t-1<CR>:norm gc$<CR>j"
end, { expr = true, silent = true, desc = "Duplicate and comment [count] lines" })

map("v", "<LocalLeader>J", function()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local vis_line = vim.fn.line("v")
  local count = vim.fn.abs(cur_line - vis_line)
  return ":t-1<CR>:norm gc" .. count .. "k<CR>" .. count + 1 .. "j"
end, { expr = true, silent = true, desc = "Duplicate and comment selected lines" })

-- navigation - mostly taken from https://github.com/tpope/vim-unimpaired
map({ "n", "x", "o" }, "[A", vim.cmd.first, { desc = "Jump to first arglist" })
map({ "n", "x", "o" }, "[a", vim.cmd.previous, { desc = "Jump to previous arglist" })
map({ "n", "x", "o" }, "]a", vim.cmd.next, { desc = "Jump to next arglist" })
map({ "n", "x", "o" }, "]A", vim.cmd.last, { desc = "Jump to last arglist" })

map({ "n", "x", "o" }, "[B", vim.cmd.bfirst, { desc = "Jump to first buffer", })
map({ "n", "x", "o" }, "[b", vim.cmd.bprevious, { desc = "Jump to previous buffer", })
map({ "n", "x", "o" }, "]b", vim.cmd.bnext, { desc = "Jump to next buffer" })
map({ "n", "x", "o" }, "]B", vim.cmd.blast, { desc = "Jump to last buffer" })

map({ "n", "x", "o" }, "[e",
  function() vim.diagnostic.goto_prev({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR }) end,
  { desc = "Jump to previous error" })
map({ "n", "x", "o" }, "]e",
  function() vim.diagnostic.goto_next({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end,
  { desc = "Jump to next error" })

-- TODO: check if lsp defauls are available. See |[d-default|, |]d-default|, and |CTRL-W_d-default|.
map({ "n", "x", "o" }, "[d", function() vim.diagnostic.goto_prev({ count = -1, float = true }) end,
  { desc = "Jump to previous diagnostic" })
map({ "n", "x", "o" }, "]d", function() vim.diagnostic.goto_next({ count = 1, float = true }) end,
  { desc = "Jump to next diagnostic" })

local cmd_call = function(cmd)
  return function()
    local _, err = pcall(vim.cmd[cmd])
    if err ~= nil then
      vim.api.nvim_err_writeln(err)
    end
  end
end

map({ "n", "x", "o" }, "[L", cmd_call("lfirst"), { desc = "Jump to first entry in loclist" })
map({ "n", "x", "o" }, "[l", cmd_call("lprevious"), { desc = "Jump to previous entry in loclist" })
map({ "n", "x", "o" }, "]l", cmd_call("lnext"), { desc = "Jump to next entry in loclist" })
map({ "n", "x", "o" }, "]L", cmd_call("llast"), { desc = "Jump to last entry in loclist" })

map({ "n", "x", "o" }, "[Q", cmd_call("cfirst"), { desc = "Jump to first entry in quickfix list" })
map({ "n", "x", "o" }, "[q", cmd_call("cprevious"), { desc = "Jump to previous entry in quickfix list" })
map({ "n", "x", "o" }, "]q", cmd_call("cnext"), { desc = "Jump to next entry in quickfix list" })
map({ "n", "x", "o" }, "]Q", cmd_call("clast"), { desc = "Jump to last entry in quickfix list" })

map({ "n", "x", "o" }, "[T", vim.cmd.tabfirst, { desc = "Jump to first tab", })
map({ "n", "x", "o" }, "[t", vim.cmd.tabprevious, { desc = "Jump to previous tab", })
map({ "n", "x", "o" }, "]t", vim.cmd.tabnext, { desc = "Jump to next tab" })
map({ "n", "x", "o" }, "]T", vim.cmd.tablast, { desc = "Jump to last tab" })

-- close quickfix and location lists
map("n", "<C-Q>", function()
  vim.cmd.cclose()
  vim.cmd.lclose()
end, { desc = "Close quickfix/location list" })

-- add undo break-points
for _, char in ipairs({ ",", ".", ";" }) do
  map("i", char, char .. "<C-G>u")
end

-- ABNT keyboard fix
for _, char in ipairs({ "~", "^", "`", "´" }) do
  map({ "", "!", "l", "t" }, char .. char, char)
end

-- utilities
map("n", "<Leader>l", "<Cmd>Lazy<CR>", { desc = "Open Lazy" })
