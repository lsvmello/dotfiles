local map = vim.keymap.set

-- scroll with arrows
map("n", "<Up>", "<C-Y>", { desc = "Scroll up" })
map("n", "<Down>", "<C-E>", { desc = "Scroll down" })

-- resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<C-W>2+", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<C-W>2-", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<C-W>2<", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<C-W>2>", { desc = "Increase Window Width" })

-- move lines
map("n", "<M-J>", ":move .+1<CR>==", { desc = "Move line down" })
map("v", "<M-J>", ":move '>+1<CR>gv=gv", { desc = "Move lines down" })
map("i", "<M-J>", "<Esc>:move .+1<CR>==gi", { desc = "Move line down" })
map("n", "<M-K>", ":move .-2<CR>==", { desc = "Move line up" })
map("v", "<M-K>", ":move '<-2<CR>gv=gv", { desc = "Move lines up" })
map("i", "<M-K>", "<Esc>:move .-2<CR>==gi", { desc = "Move line up" })

-- switch buffers
map("n", "<S-H>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-L>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "[b", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "]b", "<Cmd>bnext<CR>", { desc = "Next buffer" })

-- better navigation
map("n", "J", "mzJ`z", { desc = "Join lines" })
map("n", "<C-D>", "<C-D>zz", { desc = "Scroll half page down" })
map("n", "<C-U>", "<C-U>zz", { desc = "Scroll half page up" })
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Previous search result" })

-- better copy and paste
map("x", "<Leader>p", [["_dP]])
map({ "n", "v" }, "<Leader>y", [["+y]])
map({ "n", "v" }, "<Leader>Y", [["+Y]])
map({ "n", "v" }, "<Leader>d", [["_d]])
map({ "n", "v" }, "<Leader>D", [["_D]])

-- quickfix list
map("n", "]q", "<Cmd>cnext<CR>zz", { desc = "Next quickfix" })
map("n", "[q", "<Cmd>cprev<CR>zz", { desc = "Previous quickfix" })

-- location list
map("n", "]l", "<Cmd>lnext<CR>zz", { desc = "Next location list" })
map("n", "[l", "<Cmd>lprev<CR>zz", { desc = "Previous location list" })

-- add undo break-points
for _, char in ipairs({ ",", ".", ";" }) do
  map("i", char, char .. "<C-G>u")
end

-- utilities
map("n", "<Leader>x", "<Cmd>!chmod +x %<CR>", { desc = "Make executable", silent = true })
map("n", "<C-f>", "<Cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Change tmux session" })
