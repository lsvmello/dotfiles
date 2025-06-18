-- TODO: 1. Improve commands
-- Make stdin compatible with fish and bash
-- TODO: 2. Keymaps
-- TODO: 5. Extras
-- Make default messages hardcoded
-- Refactor parse_command_string and benchmark https://stackoverflow.com/questions/829063/how-to-iterate-individual-characters-in-lua-string
-- g< is used for other outputs, so we don't want to override it

-- local prompt_string = "\027]133;A\07❯ "
local prompt_string = "\027]133;A\07"

--- @type vim.SystemObj[]
local active_buffer_jobs = {}

local ansi_styles = {
  black = "\27[30m",
  red = "\27[31m",
  green = "\27[32m",
  yellow = "\27[33m",
  blue = "\27[34m",
  magenta = "\27[35m",
  cyan = "\27[36m",
  white = "\27[37m",
  bright_black = "\27[90m",
  bright_red = "\27[91m",
  bright_green = "\27[92m",
  bright_yellow = "\27[93m",
  bright_blue = "\27[94m",
  bright_magenta = "\27[95m",
  bright_cyan = "\27[96m",
  bright_white = "\27[97m",
  bold = "\27[1m",
  italic = "\27[3m",
  underline = "\27[4m",
  strikethrough = "\27[9m",
  reset = "\27[0m",
}

local function format_ansi_string(...)
local formatted_table = {}

  for _, item in ipairs({ ... }) do
    if type(item) == "string" then
      table.insert(formatted_table, item)
    elseif type(item) == "table" then
      local text = item[1]
      local styles = ""
      for i = 2, #item do
        styles = styles .. (ansi_styles[item[i]] or "")
      end
      table.insert(formatted_table, styles .. text .. ansi_styles.reset)
    end
  end

  return table.concat(formatted_table)
end

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

--- @param cmd RunCommand
local function build_command_table(cmd)
  local cmd_tbl = { vim.o.shell }
  vim.list_extend(cmd_tbl, vim.split(vim.o.shellcmdflag, " "))
  if cmd.stdin then
    if vim.o.shell:find("pwsh", 1, true) or vim.o.shell:find("powershell", 1, true) then
      table.insert(cmd_tbl, string.format("& { Get-Content %s | & %s }", cmd.stdin, cmd.cmd))
    elseif vim.o.shell:find("fish", 1, true) then
      table.insert(cmd_tbl, string.format("begin; %s; end < %s", cmd.cmd, cmd.stdin))
    else
      table.insert(cmd_tbl, string.format("(%s) < %s", cmd.cmd, cmd.stdin))
    end
  else
    table.insert(cmd_tbl, cmd.cmd)
  end
  return cmd_tbl
end

--- Run a command and execute a callback function when it finishes
--- @param cmd RunCommand
--- @param then_func fun(status: boolean, out?: vim.SystemCompleted)
--- @param out_func? fun(data?: string|string[])
--- @return vim.SystemObj
local function exec_command(cmd, then_func, out_func)
  then_func = vim.schedule_wrap(then_func)
  out_func = out_func and vim.schedule_wrap(out_func) or nil

  --- @type fun(string, string)?
  local std_func = out_func and function(_, data)
    out_func(data)
  end or nil

  local start_time = vim.uv.hrtime()
  if out_func then
    out_func(
      format_ansi_string(
        prompt_string,
        cmd.stdin and { "stdin", "yellow" } or "",
        cmd.stdin and " | " or "",
        cmd.cmd,
        "\n"
      )
    )
  end

  return vim.system(build_command_table(cmd), {
    text = true,
    stdout = std_func,
    stderr = std_func,
  }, function(out)
    local end_time = vim.uv.hrtime()
    local duration = (end_time - start_time) / 1e9
    local status = out.code == 0
    local message = status
        and format_ansi_string(
          "Command ",
          { "finished", "green", "bold" },
          " at ",
          os.date(),
          ", duration ",
          string.format("%.2f", duration),
          " s.\n\n"
        )
      or format_ansi_string(
        "Command ",
        { "exited abnormally", "red", "bold" },
        " with code ",
        { out.code, "red" },
        " at ",
        os.date(),
        ", duration ",
        string.format("%.2f", duration),
        " s.\n\n"
      )

    if out_func then
      out_func(message)
    end

    then_func(status, out)
  end)
end

--- @param buf integer
local function run_buffer_sequence(buf)
  local chan = vim.api.nvim_open_term(buf, {})

  local out_func = function(data)
    if not data then
      return
    end
    vim.api.nvim_chan_send(chan, data)
  end

  local then_func = function()
    out_func(format_ansi_string("Execution finished at ", os.date(), ".\n"))
    active_buffer_jobs[buf] = nil
    vim.fn.chanclose(chan)
  end

  local sequence = vim.b[buf].run_sequence
  out_func(format_ansi_string("Execution started at ", os.date(), "; current-directory: " .. vim.fn.getcwd() .. "\n\n"))

  local function skip_command_and_next(index, reason)
    local cmd = sequence[index]
    if not cmd then
      return then_func()
    end

    out_func(
      format_ansi_string(
        prompt_string,
        cmd.cmd,
        { " skipped because previous command ", "bright_black", "italic" },
        reason,
        { ".\n", "bright_black", "italic" }
      )
    )

    skip_command_and_next(index + 1, { "skipped", "bright_black", "underline", "italic" })
  end

  local function run_command_and_next(index)
    local cmd = sequence[index]
    if not cmd then
      return then_func()
    end

    local then_run_func = function(status)
      local next_index = index + 1
      if cmd.cond == nil or cmd.cond == status then
        run_command_and_next(next_index)
      else
        local reason = status and { "exited successfully", "green", "italic" }
        or { "exited abnormally", "red", "italic" }
        skip_command_and_next(next_index, reason)
      end
    end
    local curr_job = exec_command(cmd, then_run_func, out_func)
    active_buffer_jobs[buf] = curr_job
  end

  run_command_and_next(1)
end

--- @param sequence RunSequence
--- @return integer, integer
local function create_output_buffer(sequence, smods)
  local buf = vim.api.nvim_create_buf(true, false)

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].modified = false

  vim.keymap.set("n", "q", "<Cmd>quit<CR>", { silent = true, buffer = buf })
  vim.keymap.set("n", "<C-r>", function()
    run_buffer_sequence(buf)
  end, { buffer = buf })
  vim.keymap.set("n", "<C-c>", function()
    local curr_job = active_buffer_jobs[buf]
    if curr_job and not curr_job:is_closing() then
      curr_job:kill(2)
    end
  end, { silent = true, buffer = buf })
  vim.api.nvim_create_autocmd("TextChanged", {
    buffer = buf,
    callback = function(event)
      local lines = vim.api.nvim_buf_get_lines(event.buf, -vim.o.lines, -1, false)
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
        vim.api.nvim_set_option_value("modifiable", true, { buf = event.buf })
        vim.api.nvim_buf_set_lines(buf, last_index - 1, last_index, false, { string.rep(" ", 20) })
        vim.api.nvim_set_option_value("modifiable", false, { buf = event.buf })
        last_index = last_index - 1
      end

      local win = vim.fn.bufwinid(event.buf)
      if win > 0 then
        pcall(vim.api.nvim_win_set_cursor, win, { last_index, 0 })
      end
    end,
  })
  -- TODO: replace with some extmark?
  vim.keymap.set("n", "g?", "<Cmd>echo 'A help should be show now'<CR>", { buffer = buf })
  -- TODO: implement <C-q> here
  vim.keymap.set("n", "<C-q>", "<Cmd>echo 'Should populate quickfix list'<CR>", { buffer = buf })
  -- TODO: implement [e and ]e
  vim.keymap.set("n", "[e", "<Cmd>echo 'Should go to next error'<CR>", { buffer = buf })
  vim.keymap.set("n", "]e", "<Cmd>echo 'Should go to previous error'<CR>", { buffer = buf })
  vim.keymap.set("n", "gi", function()
    local first_command = vim.b[buf].run_sequence[1]
    if not first_command.stdin then
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
    vim.cmd.edit(first_command.stdin)
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
  end, { buffer = buf })

  vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })
  vim.api.nvim_create_autocmd("BufDelete", {
    buffer = buf,
    callback = function()
      local curr_job = active_buffer_jobs[buf]
      if curr_job and not curr_job:is_closing() then
        curr_job:kill(15)
      end
    end,
  })

  local win = get_or_create_output_window(buf, smods)
  vim.api.nvim_win_set_buf(win, buf)

  vim.api.nvim_buf_set_name(buf, string.format("Run output[%d]: %s", buf, sequence))
  vim.b[buf].run_sequence = sequence

  return buf, win
end
--- @class RunCommand
--- @field cmd string
--- @field stdin? string
--- @field cond? boolean Condition on which the next command should run

---@alias RunSequence RunCommand[]

local sequence_mt = {
  __tostring = function(tbl)
    local str = {}
    for i, val in ipairs(tbl) do
      if val.cond == nil then
        table.insert(str, val.cmd .. (i < #tbl and ";" or ""))
      else
        table.insert(str, val.cmd .. (val.cond and " &&" or " ||"))
      end
    end
    return table.concat(str, " ")
  end,
}

---Parses a string into a RunSequence
---@param cmd string Command string to parse
---@return RunSequence Parsed RunSequence
local function parse_commands_string(cmd)
  local result = {} ---@as RunSequence

  local cmd_index = 1
  local in_single_quotes = false
  local in_double_quotes = false

  for i = 1, #cmd do
    local char = cmd:sub(i, i)

    if char == "'" and not in_double_quotes then
      in_single_quotes = not in_single_quotes
    elseif char == '"' and not in_single_quotes then
      in_double_quotes = not in_double_quotes
    elseif char == ";" and not in_single_quotes and not in_double_quotes then
      local segment = vim.trim(cmd:sub(cmd_index, i - 1))
      table.insert(result, { cmd = vim.trim(segment) })
      cmd_index = i + 1
    elseif char == "&" and cmd:sub(i + 1, i + 1) == char and not in_single_quotes and not in_double_quotes then
      local segment = vim.trim(cmd:sub(cmd_index, i - 1))
      table.insert(result, { cmd = segment, cond = true })
      cmd_index = i + 2
    elseif char == "|" and cmd:sub(i + 1, i + 1) == char and not in_single_quotes and not in_double_quotes then
      local segment = vim.trim(cmd:sub(cmd_index, i - 1))
      table.insert(result, { cmd = segment, cond = false })
      cmd_index = i + 2
    end
  end

  if cmd_index <= #cmd then
    local segment = vim.trim(cmd:sub(cmd_index))
    table.insert(result, { cmd = vim.trim(segment) })
  end

  return setmetatable(result, sequence_mt)
end

local run_ns = vim.api.nvim_create_namespace("run")

--- @param buf number
--- @param opts table
--- @param cmd string
--- @param timer? uv.uv_timer_t
--- @return number extmark id
local function create_loading_extmark(buf, opts, cmd, timer)
    local spinner_idx = 1
    local spinner_tbl = { "🌕", "🌔", "🌓", "🌒", "🌑", "🌘", "🌗", "🌖" }

    local extmark_id = vim.api.nvim_buf_set_extmark(buf, run_ns, opts.line1 - 1, 0, {
      end_row = opts.line2 - 1,
      end_col = #vim.fn.getline(opts.line2),
      hl_group = "NonText",
      strict = false,
      hl_mode = "combine",
      hl_eol = true,
      virt_text = { { cmd, "NonText" } },
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
          details.virt_text = { { spinner_tbl[spinner_idx] .. " " .. cmd, "NonText" } }
          vim.api.nvim_buf_set_extmark(buf, run_ns, row, col, details)
          spinner_idx = spinner_idx % #spinner_tbl + 1

        end)
      )
    end

    return extmark_id
end

local function run_command(opts)
  if opts.args == "" and (opts.bang and not vim.t.last_run_sequence) then
    return vim.api.nvim_echo({ { opts.name ..": No command provided.", "ErrorMsg" } }, false, { err = true })
  end

  local curr_buf = vim.api.nvim_get_current_buf()
  if opts.range > 0 then
    -- TODO: Improve the "sometimes command/sometimes sequence" situation
    local tempfile = vim.fn.tempname()
    local lines = vim.api.nvim_buf_get_lines(curr_buf, opts.line1 - 1, opts.line2, true)
    if vim.fn.writefile(lines, tempfile) == -1 then
      return vim.api.nvim_echo({ { opts.name ..": Could not write temporary file to use as stdin.", "ErrorMsg" } }, false, { err = true })
    end
    local cmd = { cmd = opts.bang and vim.t.last_run_sequence[1] or opts.args, stdin = tempfile }

    local timer = vim.uv.new_timer()
    local extmark_id = create_loading_extmark(curr_buf, opts, cmd.cmd, timer)

    exec_command(cmd, function(status, out)
      if timer then
        timer:stop()
        timer:close()
      end
      pcall(vim.api.nvim_buf_del_extmark, curr_buf, run_ns, extmark_id)

      local replacement = status and out.stdout or out.stderr .. out.stdout
      vim.api.nvim_buf_set_lines(curr_buf, opts.line1 - 1, opts.line2, false, vim.split(replacement or "", "\n"))
    end)
    vim.t.last_run_sequence = { cmd }
  else
    local run_sequence = opts.bang and vim.t.last_run_sequence or parse_commands_string(opts.args)
    local buf = create_output_buffer(run_sequence, opts.smods)
    run_buffer_sequence(buf)
    vim.t.last_run_sequence = run_sequence
  end
end

local run_command_args = {
  bang = true,
  complete = "shellcmdline",
  desc = "Non-blocking bang command",
  nargs = "?",
  range = true,
}

vim.api.nvim_create_user_command("Bang", run_command, run_command_args)
vim.api.nvim_create_user_command("B", run_command, run_command_args)
