local function get_or_create_output_window(buf, smods)
  local split = vim.g.run_default_split or "below"
  if smods.split == "aboveleft" then
    split = smods.vertical and "left" or "above"
  elseif smods.split == "belowright" then
    split = smods.vertical and "right" or "below"
  elseif smods.split == "topleft" then
    split =  smods.vertical and "left" or "above"
  elseif smods.split == "botright" then
    split = smods.vertical and "right" or "below"
  end

  local win = split == "nosplit" and vim.api.nvim_get_current_win()
    or vim.api.nvim_open_win(buf, true, { win = -1, split = split })

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].statuscolumn = ""
  vim.wo[win].signcolumn = "no"

  return win
end

---@param run_cmd RunCommand
---@param pty boolean
local function build_command_table(run_cmd, pty)
  local cmd_tbl = { vim.o.shell }
  vim.list_extend(cmd_tbl, vim.split(vim.o.shellcmdflag, " "))
  if run_cmd.stdin then
    if vim.o.shell:find("pwsh", 1, true) or vim.o.shell:find("powershell", 1, true) then
      table.insert(cmd_tbl, string.format("& { Get-Content %s | & %s }", run_cmd.stdin, run_cmd.cmd))
    elseif vim.o.shell:find("fish", 1, true) then
      table.insert(cmd_tbl, string.format("begin; %s; end < %s", run_cmd.cmd, run_cmd.stdin))
    else
      table.insert(cmd_tbl, string.format("(%s) < %s", run_cmd.cmd, run_cmd.stdin))
    end
  else
    if pty then
      table.insert(cmd_tbl, "echo \027[4;H\07 && " .. run_cmd.cmd)
    else
      table.insert(cmd_tbl, run_cmd.cmd)
    end
  end
  return cmd_tbl
end

---@param cmd RunCommand
---@param out_func fun(data: string[])
---@param then_func fun(code: number)
---@param pty boolean
---@return number
local function exec_command(cmd, out_func, then_func, pty)
  return vim.fn.jobstart(build_command_table(cmd, pty), {
    pty = pty,
    stdout_buffered = not pty,
    stderr_buffered = not pty,
    height = vim.api.nvim_win_get_height(0),
    width = vim.api.nvim_win_get_width(0),
    on_stdout = function(_, data, _)
      out_func(data)
    end,
    on_stderr = function(_, data, _)
      out_func(data)
    end,
    on_exit = function(_, code)
      then_func(code)
    end
  })
end

---@param buf integer
local function run_command_output_buffer(buf)
  local chan = vim.api.nvim_open_term(buf, {})

  local out_func = function(data)
    local content = table.concat(data, "\n")
                    :gsub("\027%[2J", "") -- remove clear screen
                    :gsub("\027%[H", "")  -- remove cursor home
    vim.api.nvim_chan_send(chan, content)
  end

  local cmd = vim.b[buf].run_cmd
  local start_time = vim.uv.hrtime()
  local prompt_string = "\027]133;A\07"
  local cmd_string = "\n" .. prompt_string
  if cmd.stdin then
    cmd_string = cmd_string .. "\27[33mstdin\27[0m | "
  end
  cmd_string = cmd_string .. cmd.cmd .. "\n"
  out_func({
    "Execution started at " .. os.date() .. "; current-directory: " .. vim.fn.getcwd(),
    cmd_string
   })

  local then_func = function(code)
    local end_time = vim.uv.hrtime()
    local duration = (end_time - start_time) / 1e9
    local message = "\nExecution "
    if code == 0 then
      message = message .. "\27[32m\27[1mfinished\27[0m at " .. os.date()
            .. ", duration " .. string.format("%.2f", duration) .. " s."
    else
      message = message .. "\27[31m\27[1mexited abnormally\27[0m with code \27[31m"
            .. code .. "\27[0m at " .. os.date() .. ", duration "
            .. string.format("%.2f", duration) .. " s."
    end
    out_func({ message })

    vim.b[buf].run_jobid = nil
    vim.fn.chanclose(chan)
  end

  vim.b[buf].run_jobid = exec_command(cmd, out_func, then_func, true)
end

---@param buf number
local function stop_buffer_job(buf)
  if vim.b[buf].run_jobid then
    vim.fn.jobstop(vim.b[buf].run_jobid)
  end
end


local function set_buffer_keymaps(buf)
  vim.keymap.set("n", "q", "<Cmd>quit<CR>", { silent = true, buffer = buf })
  vim.keymap.set("n", "<C-r>", function()
    if vim.b[buf].run_jobid == nil then
      run_command_output_buffer(buf)
    end
  end, { buffer = buf })
  vim.keymap.set("n", "<C-c>", function()
    stop_buffer_job(buf)
  end, { silent = true, buffer = buf })
  vim.api.nvim_create_autocmd("TextChanged", {
    buffer = buf,
    callback = function(event)
      local total_buf_lines = vim.api.nvim_buf_line_count(event.buf)
      local slice_start = math.max(0, total_buf_lines - vim.o.lines)
      local lines = vim.api.nvim_buf_get_lines(event.buf, slice_start, -1, false)
      local lines_count = #lines

      local empty_lines = 0
      while lines[lines_count - empty_lines] == "" do
        empty_lines = empty_lines + 1
      end

      if empty_lines == lines_count then
        return
      end

      local last_index = lines_count - empty_lines
      if lines[last_index]:find("[Terminal closed]", 1, true) then
        local abs_line = slice_start + last_index - 1
        vim.bo[event.buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, abs_line, abs_line + 1, false, { })
        vim.bo[event.buf].modifiable = false
        last_index = last_index - 1
      end

      vim.cmd("norm G")
    end,
  })
  -- TODO: implement or replace with some extmark?
  vim.keymap.set("n", "g?", "<Cmd>echo 'A help should be show now'<CR>", { buffer = buf })
  vim.keymap.set("n", "gi", function()
    local run_cmd = vim.b[buf].run_cmd
    if not run_cmd.stdin then
      return
    end
    local win_width = vim.api.nvim_win_get_width(0) - 1
    local fbuf = vim.api.nvim_create_buf(false, true)
    local fwin = vim.api.nvim_open_win(fbuf, true, {
      relative = "win",
      width = math.floor(win_width / 2),
      height = vim.api.nvim_win_get_height(0) - 1,
      row = 0,
      col = win_width,
      anchor = "NE",
    })
    vim.cmd.edit(run_cmd.stdin)
    vim.wo[fwin].number = false
    vim.wo[fwin].relativenumber = false
    vim.wo[fwin].statuscolumn = ""
    vim.wo[fwin].signcolumn = "no"
    vim.api.nvim_create_autocmd({ "CursorMoved", "WinLeave" }, {
      once = true,
      buffer = buf,
      callback = function()
        if vim.api.nvim_win_is_valid(fwin) then
          vim.api.nvim_win_close(fwin, true)
        end
      end,
    })
    vim.api.nvim_create_autocmd("BufDelete", {
      buffer = buf,
      callback = function()
        vim.cmd("silent! bdelete! " .. tostring(fbuf))
      end,
    })
  end, { buffer = buf, desc = "Show/Edit input file used as stdin" })
end

---@param run_cmd RunCommand
---@return integer, integer
local function create_output_buffer(run_cmd, smods)
  local buf = vim.api.nvim_create_buf(true, false)

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].modified = false

  set_buffer_keymaps(buf)

  vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })
  vim.api.nvim_create_autocmd("BufDelete", {
    buffer = buf,
    callback = function()
      stop_buffer_job(buf)
    end,
  })

  local win = get_or_create_output_window(buf, smods)
  vim.api.nvim_win_set_buf(win, buf)

  vim.api.nvim_buf_set_name(buf, string.format("Run output[%d]: %s", buf, run_cmd.cmd))
  vim.b[buf].run_cmd = run_cmd

  return buf, win
end
---@class RunCommand
---@field cmd string
---@field stdin? string

local run_ns = vim.api.nvim_create_namespace("run")

---@param buf number
---@param line_start number
---@param line_end number
---@param cmd_str string
---@return number, uv.uv_timer_t?
local function create_loading_extmark(buf, line_start, line_end, cmd_str)
  local spinner_idx = 1
  local spinner_tbl = { "🌕", "🌔", "🌓", "🌒", "🌑", "🌘", "🌗", "🌖" }
  local timer = vim.uv.new_timer()

  local extmark_id = vim.api.nvim_buf_set_extmark(buf, run_ns, line_start, 0, {
    end_row = line_end - 1,
    end_col = #vim.fn.getline(line_end),
    hl_group = "NonText",
    strict = false,
    hl_mode = "combine",
    hl_eol = true,
    virt_text = { { cmd_str, "NonText" } },
  })

  if timer then
    timer:start(
      0,
      1000 / #spinner_tbl,
      vim.schedule_wrap(function()
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        local extmark = vim.api.nvim_buf_get_extmark_by_id(buf, run_ns, extmark_id, { details = true })
        if not extmark or not extmark[3] then return end

        local row, col, details = unpack(extmark)
        details.id = extmark_id
        details.ns_id = nil -- clean ns_id for nvim_buf_set_extmark
        details.hl_mode = "combine" -- TODO: this should already exist, open an issue
        details.virt_text = { { spinner_tbl[spinner_idx] .. " " .. cmd_str, "NonText" } }
        vim.api.nvim_buf_set_extmark(buf, run_ns, row, col, details)
        spinner_idx = spinner_idx % #spinner_tbl + 1

      end)
    )
  end

  return extmark_id, timer
end

---@param run_cmd RunCommand
---@param buf number
---@param line_start number
---@param line_end number
local run_command_replace_lines = function(run_cmd, buf, line_start, line_end)
  local extmark_id, timer = create_loading_extmark(buf, line_start, line_end, run_cmd.cmd)

  local output = {}
  local out_func = function(data)
    for _, line in ipairs(data) do
      local content = line:gsub("\r", "")
      table.insert(output, content)
    end
  end

  local then_func = function(_)
    if timer then
      timer:stop()
      timer:close()
    end
    pcall(vim.api.nvim_buf_del_extmark, buf, run_ns, extmark_id)

    vim.api.nvim_buf_set_lines(buf, line_start, line_end, false, output)
  end
  exec_command(run_cmd, out_func, then_func, false)
end

local function run_command(opts)
  if opts.args == "" then
    return vim.api.nvim_echo({ { opts.name ..": No command provided.", "ErrorMsg" } }, false, { err = true })
  end

  local curr_buf = vim.api.nvim_get_current_buf()
  local run_cmd = { cmd = opts.args }
  if opts.range > 0 then
    local tempfile = vim.fn.tempname()
    local lines = vim.api.nvim_buf_get_lines(curr_buf, opts.line1 - 1, opts.line2, true)
    if vim.fn.writefile(lines, tempfile) == -1 then
      return vim.api.nvim_echo({ { opts.name ..": Could not write temporary file to use as stdin.", "ErrorMsg" } }, false, { err = true })
    end

    run_cmd.stdin = tempfile
  end

  if opts.bang then
    run_command_replace_lines(run_cmd, curr_buf, opts.line1 - 1, opts.line2)
  else
    local buf = create_output_buffer(run_cmd, opts.smods)
    run_command_output_buffer(buf)
  end
end

local run_command_args = {
  bang = true,
  complete = "shellcmdline",
  desc = "Non-blocking bang command",
  nargs = "?",
  range = true,
}

vim.api.nvim_create_user_command("Run", run_command, run_command_args)
vim.api.nvim_create_user_command("R", run_command, run_command_args)
