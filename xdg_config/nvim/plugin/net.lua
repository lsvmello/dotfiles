if vim.g.net_lua_disabled then
  return
end

vim.g.loaded_netrw = "disabled"
vim.g.loaded_netrwPlugin = "disabled"

vim.g.net_spinner_disabled = vim.F.if_nil(vim.g.net_spinner_disabled, false)
vim.g.net_spinner_table =
  vim.F.if_nil(vim.g.net_spinner_table, { "🌕", "🌔", "🌓", "🌒", "🌑", "🌘", "🌗", "🌖" })
vim.g.net_spinner_refresh_rate = vim.F.if_nil(vim.g.net_spinner_refresh_rate, 1000 / #vim.g.net_spinner_table)

local network_augroup = vim.api.nvim_create_augroup("Network", { clear = true })
local network_ns = vim.api.nvim_create_namespace("Network")

local readable_protocols = { "file://*", "ftp://*", "ftps://*", "http://*", "https://*", "scp://*", "sftp://*" }
local writable_protocols = { "ftp://*", "ftps://*", "scp://*", "sftp://*" }

--- @param event_prefix string
--- @param action fun(tempfile: string, line: number)
local function create_readable_autocmd(event_prefix, action)
  vim.api.nvim_create_autocmd(event_prefix .. "Cmd", {
    group = network_augroup,
    pattern = readable_protocols,
    callback = function(event)
      local match = vim.fn.fnameescape(event.match)
      local win_view = vim.fn.winsaveview()
      local bufnr = vim.api.nvim_get_current_buf()
      local extmark_line = vim.fn.line(".") - 1
      local extmark_id = vim.api.nvim_buf_set_extmark(bufnr, network_ns, extmark_line, 0, {
          virt_lines = { { { "⤷ " .. event.file, "NonText" } } },
      })

      --- @type uv.uv_timer_t?
      local timer = vim.uv.new_timer()
      if not vim.g.net_spinner_disabled then
        local refresh_rate = vim.g.net_spinner_refresh_rate
        local spinner_tbl = vim.g.net_spinner_table
        local spinner_idx = 1

        if timer then
          timer:start(refresh_rate, refresh_rate, vim.schedule_wrap(function()
            if not vim.api.nvim_buf_is_valid(bufnr) then
              return
            end
            local extmark = vim.api.nvim_buf_get_extmark_by_id(bufnr, network_ns, extmark_id, {})
            local row, col = unpack(extmark)
            if not row or not col then
              return
            end

            vim.api.nvim_buf_set_extmark(bufnr, network_ns, row, col, {
              id = extmark_id,
              virt_lines = { { { "⤷ " .. spinner_tbl[spinner_idx] .. event.file, "NonText" } } },
            })
            spinner_idx = spinner_idx % #spinner_tbl + 1
          end))
        end
      end
      vim.api.nvim_exec_autocmds(event_prefix .. "Pre", { pattern = match })

      local tempfile = vim.fn.tempname()
      --- @type vim.NetOpts
      local opts = vim.tbl_deep_extend("force", vim.g.net_opts or {}, vim.b[bufnr].net_opts or {})
      opts.on_exit = vim.schedule_wrap(function(result)
        vim.api.nvim_buf_call(bufnr, function()
          if timer then
            timer:stop()
            timer:close()
          end
          pcall(vim.api.nvim_buf_del_extmark, bufnr, network_ns, extmark_id)

          if result.ok then
            action(tempfile, extmark_line)
          else
            vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, vim.split(result.error, "\n"))
          end

          vim.fn.winrestview(win_view)
          vim.b[bufnr].net_result = result
          vim.api.nvim_exec_autocmds(event_prefix .. "Post", { pattern = match })
          vim.fn.delete(tempfile)
        end)
      end)
      require("net").download(event.file, tempfile, opts)
    end,
  })
end

create_readable_autocmd("FileRead", function(tempfile, line)
  vim.cmd(string.format("silent! %dread %s", line, tempfile))
end)
create_readable_autocmd("BufRead", function(tempfile, line)
  vim.cmd(string.format("silent! %dread %s", line, tempfile))
end)
create_readable_autocmd("Source", function(tempfile)
  vim.cmd("silent! source " .. tempfile)
end)

--- @param event_prefix string
--- @param action fun(string, vim.api.keyset.create_autocmd.callback_args)
local function create_writable_autocmd(event_prefix, action)
  vim.api.nvim_create_autocmd(event_prefix .. "Cmd", {
    group = network_augroup,
    pattern = writable_protocols,
    callback = function(event)
      local win_view = vim.fn.winsaveview()
      local match = vim.fn.fnameescape(event.match)
      vim.api.nvim_exec_autocmds(event_prefix .. "Pre", { pattern = match })

      local tempfile = vim.fn.tempname()
      -- TODO: continue implementing this
      action(tempfile, event)
      vim.schedule(function()
        vim.fn.delete(tempfile)
      end)

      vim.fn.winrestview(win_view)
      vim.api.nvim_exec_autocmds(event_prefix .. "Post", { pattern = match })
    end,
  })
end

create_writable_autocmd("BufWrite", function(tempfile, event)
  vim.cmd(string.format("silent! write! %s", tempfile))
end)
create_writable_autocmd("FileWrite", function(tempfile, event)
  vim.cmd(string.format("silent! %d,%dwrite! %s", vim.fn.line("'["), vim.fn.line("']"), tempfile))
end)

