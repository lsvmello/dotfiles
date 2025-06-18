vim.g.bigfile_size = vim.F.if_nil(vim.g.bigfile_size, 500 * 1024) -- 500KB
vim.g.bigfile_lines = vim.F.if_nil(vim.g.bigfile_lines, 1000)

local bigfile_augroup = vim.api.nvim_create_augroup("bigfile", { clear = true })

vim.filetype.add({
  pattern = {
    [".*"] = {
      function(path, buf)
        if not path or buf < 1 or vim.bo[buf].filetype == "bigfile" then
          return
        end

        local size = vim.fn.getfsize(path)
        if size > vim.g.bigfile_size then
          return "bigfile"
        end

        local lines = vim.api.nvim_buf_line_count(buf)
        local lines_ratio = size > 0 and ((size - lines) / lines) or lines
        if lines_ratio > vim.g.bigfile_lines then
          return "bigfile"
        end
      end,
    },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  group = bigfile_augroup,
  pattern = "bigfile",
  callback = function(ev)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ev.buf) then
        vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
      end
    end)
  end,
})
