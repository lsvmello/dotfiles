if vim.g.bigfile_loaded then
  return
end

vim.g.bigfile_loaded = true
vim.g.bigfile_size = 1024 * 1024 * 1.5

local bigfile_augroup = vim.api.nvim_create_augroup("bigfile", { clear = true })

vim.filetype.add({
  pattern = {
    [".*"] = {
      function(path, buf)
        if vim.bo[buf] and vim.bo[buf].filetype ~= "bigfile" and path then
          local file_size = vim.fn.getfsize(path)
          if file_size > vim.g.bigfile_size then
            vim.b[buf].file_size = file_size
            return "bigfile"
          end
        end
        return nil
      end,
    },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  group = bigfile_augroup,
  pattern = "bigfile",
  callback = function(ev)
    vim.schedule(function()
      vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
    end)
  end,
})
