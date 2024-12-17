vim.opt_local.commentstring = "# %s"

vim.keymap.set("n", "<CR>", ":.lua<CR>", { silent = true, buffer = true, desc = "Execute current line" })
vim.keymap.set("v", "<CR>", ":lua<CR>", { silent = true, buffer = true, desc = "Execute current selection" })
vim.keymap.set("n", "<LocalLeader><CR>", "<Cmd>source %<CR>", { silent = true, buffer = true, desc = "Source current file" })
