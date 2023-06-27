local map = vim.keymap.set

map({ "n", "v", "i" }, "<M-a>", "<Esc>ggVG$", { desc = "Select All" })

-- scroll with arrows
map("n", "<Up>", "<C-Y>", { desc = "Scroll up" })
map("n", "<Down>", "<C-E>", { desc = "Scroll down" })

-- resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<C-W>2+", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<C-W>2-", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<C-W>2<", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<C-W>2>", { desc = "Increase Window Width" })

-- move lines
map("n", "<M-j>", ":move .+1<CR>==", { desc = "Move line down" })
map("v", "<M-j>", ":move '>+1<CR>gv=gv", { desc = "Move lines down" })
map("i", "<M-j>", "<Esc>:move .+1<CR>==gi", { desc = "Move line down" })
map("n", "<M-k>", ":move .-2<CR>==", { desc = "Move line up" })
map("v", "<M-k>", ":move '<-2<CR>gv=gv", { desc = "Move lines up" })
map("i", "<M-k>", "<Esc>:move .-2<CR>==gi", { desc = "Move line up" })

-- better navigation
map("n", "J", "mzJ`z", { desc = "Join lines" })
map("n", "<C-D>", "<C-D>zz", { desc = "Scroll half page down" })
map("n", "<C-U>", "<C-U>zz", { desc = "Scroll half page up" })
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Previous search result" })

-- indentation
map("v", ">", ">gv")
map("v", "<", "<gv")

-- better copy and paste
map("n", "<LocalLeader>p", [["+p]], { desc = "Put the text from clipboard after the cursor" })
map("n", "<LocalLeader>P", [["+P]], { desc = "Put the text from clipboard before the cursor" })
map("x", "<LocalLeader>p", [["_dP]], { desc = "Replace the text wihout changing the registers" })
map({ "n", "v" }, "<LocalLeader>y", [["+y]], { desc = "Yank text into the clipboard" })
map({ "n", "v" }, "<LocalLeader>Y", [["+Y]], { desc = "Yank text into the clipboard (linewise)" })
map({ "n", "v" }, "<LocalLeader>d", [["_d]], { desc = "Delete the text without changing the registers" })
map({ "n", "v" }, "<LocalLeader>D", [["_D]], { desc = "Delete until the EOL without changing the registers" })

-- add undo break-points
for _, char in ipairs({ ",", ".", ";" }) do
  map("i", char, char .. "<C-G>u")
end

-- pt-br keyboard fix
for _, char in ipairs({ "~", "^", "`", "´" }) do
  map("", char .. char, char)
end

-- utilities
map("n", "<Leader>c", function()
  vim.cmd.tabnew(vim.fn.stdpath("config"))
end, { desc = "Edit Neovim's configuration files" })

if vim.fn.executable("tmux") then
  map("n", "<C-f>", "<Cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Change tmux session" })
end
