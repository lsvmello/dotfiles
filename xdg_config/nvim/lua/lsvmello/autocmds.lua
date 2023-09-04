local augroup = vim.api.nvim_create_augroup("lsvmello.autocmds", { clear = true })

-- check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { group = augroup, command = "checktime" })

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "fugitive",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "startuptime",
  },
  callback = function(event)
    vim.api.nvim_set_option_value("buflisted", false, { buf = event.buf })
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- prompts to create not existing dir when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function(event)
    if not event.match:match("^%w%w+://") then
      local directory = vim.fn.fnamemodify(vim.loop.fs_realpath(event.match) or event.match, ":p:h")
      if vim.fn.isdirectory(directory) == 0 then
        vim.ui.input(
          {
            prompt = "'" .. directory .. "' does not exits, do you want to create it? (y/n): ",
            default = "y"
          },
          function(input)
            if input == "y" or input == "Y" then
              vim.fn.mkdir(directory, "p")
            end
          end)
      end
    end
  end,
})
