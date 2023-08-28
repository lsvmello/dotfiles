-- CTRL-] does not work properly on pt-br keyboards
vim.keymap.set("", "gd", "<C-]>", { desc = "Jump to definition of the keyword under the cursor" })
vim.keymap.set("", "gD", "<C-]>", { desc = "Jump to definition of the keyword under the cursor" })
