--- @class vim.NetResult
--- @field url string
--- @field ok boolean
--- @field error? string
--- @field body? string
--- @field headers? table<string, string>
--- @field status? { code: number, text: string }

--- @class vim.NetOpts
--- @field timeout? integer
--- @field auth? { user: string, password: string }
--- @field headers? string[]
--- @field on_exit? fun(result: vim.NetResult)
--- @field method? "CONNECT"|"DELETE"|"GET"|"HEAD"|"OPTIONS"|"PATCH"|"POST"|"PUT"|"TRACE"
--- @field body? string

--- @class vim.NetState
--- @field url string
--- @field handle? vim.SystemObj
--- @field result? vim.NetResult

--- @class vim.NetObj
--- @field url string
--- @field private _state vim.NetState
--- @field wait fun(self: vim.NetObj, timeout?: integer): vim.NetResult
--- @field cancel fun(self: vim.NetObj)
--- @field is_cancelling fun(self: vim.NetObj): boolean
local NetObj = {}

--- @param state vim.NetState
--- @return vim.NetObj
local function new_netobj(state)
  return setmetatable({
    url = state.url,
    _state = state,
  }, { __index = NetObj })
end

--- @param timeout? integer
--- @return vim.NetResult
function NetObj:wait(timeout)
    local state = self._state
    state.handle:wait(timeout)
    return state.result
end

function NetObj:cancel()
  self._state.handle:kill(2) -- SIGINT
end

--- @return boolean
function NetObj:is_cancelling()
  return self._state.handle:is_closing()
end

--- @param url string
--- @param curl_opts string[]
--- @param net_opts vim.NetOpts
--- @param on_exit fun(vim.SystemObj)
--- @return vim.SystemObj
local function _run_curl(url, curl_opts, net_opts, on_exit)
    net_opts = net_opts or {}

    local command = { "curl", "--url", url }
    for _, option in ipairs(curl_opts) do
      table.insert(command, option)
    end

    --- @type vim.SystemOpts
    local sys_opts = {
        text = true,
        timeout = net_opts.timeout,
        stdin = net_opts.body,
    }

    return vim.system(command, sys_opts, on_exit)
end

--- @param obj vim.SystemCompleted
--- @return boolean, string?
local function check_curl_status(obj)
  if obj.code == 0 then
    return true, nil
  end

  return false, obj.code == 124 and "User-defined timeout limit reached." or obj.stderr
end

--- @param opts vim.NetOpts
local function build_common_curl_opts(opts)
  local curl_opts = {}

  if opts.auth then
    table.insert(curl_opts, "--user")
    table.insert(curl_opts, string.format("%s:%s", opts.auth.user, opts.auth.password))
  end

  if opts.headers then
    for k, v in pairs(opts.headers) do
      table.insert(curl_opts, "--header")
      table.insert(curl_opts, string.format("%s: %s", k, v))
    end
  end

  if opts.method then
    table.insert(curl_opts, "--request")
    table.insert(curl_opts, opts.method)
  end

  -- Add common flags
  table.insert(curl_opts, "--compressed")
  table.insert(curl_opts, "--globoff")
  table.insert(curl_opts, "--location")
  table.insert(curl_opts, "--show-error")
  table.insert(curl_opts, "--silent")

  if opts.body then
    table.insert(curl_opts, "--data-binary")
    table.insert(curl_opts, "@-")
  end

  return curl_opts
end

--- @param url string
--- @param path string
--- @param opts? vim.NetOpts
--- @return vim.NetObj
local function _http_download(url, path, opts)
  opts = opts or {}
  local curl_opts = build_common_curl_opts(opts)

  table.insert(curl_opts, "--create-dirs")

  -- Add the output option
  table.insert(curl_opts, "--output")
  table.insert(curl_opts, vim.fn.fnameescape(vim.fn.fnamemodify(path, ":p")))

  --- @type vim.NetState
  local state = { url = url }

  local on_exit = function(obj)
    local ok, error = check_curl_status(obj)

    --- @type vim.NetResult
    state.result = {
      url = url,
      ok = ok,
      error = error,
    }

    if opts.on_exit then
      opts.on_exit(state.result)
    end
  end

  state.handle = _run_curl(url, curl_opts, opts, on_exit)

  return new_netobj(state)
end

--- @param url string
--- @param path string
--- @param opts? vim.NetOpts
--- @return vim.NetObj
local function _http_upload(url, path, opts)
  opts = opts or {}
  local curl_opts = build_common_curl_opts(opts)

  -- Add the output option
  table.insert(curl_opts, "--upload-file")
  table.insert(curl_opts, vim.fn.fnameescape(vim.fn.fnamemodify(path, ":p")))

  --- @type vim.NetState
  local state = { url = url }

  local on_exit = function(obj)
    local ok, error = check_curl_status(obj)

    --- @type vim.NetResult
    state.result = {
      url = url,
      ok = ok,
      error = error,
    }

    if opts.on_exit then
      opts.on_exit(state.result)
    end
  end

  state.handle = _run_curl(url, curl_opts, opts, on_exit)

  return new_netobj(state)
end

--- @return vim.NetObj
local function _http_request(url, opts)
  opts = opts or {}
  local curl_opts = build_common_curl_opts(opts)

  -- Add options to dump headers and body to stdout
  table.insert(curl_opts, "--include") -- Include headers in the output
  table.insert(curl_opts, "--output")
  table.insert(curl_opts, "-") -- Output to stdout

  --- @type vim.NetState
  local state = { url = url }

  local on_exit = function(obj)
    local headers = {}
    local status = { code = 0, text = "Unknown error" }
    local body
    local ok, error = check_curl_status(obj)

    if ok then
      local output = obj.stdout
      local header_end = output:find("\r\n\r\n") or output:find("\n\n")
      if header_end then
        local headers_content = output:sub(1, header_end - 1)

        -- Parse status line
        local status_code, status_text = headers_content:match("HTTP/%d[%.%d]* (%d+) (.-)\r?\n")
        status.code = tonumber(status_code)
        status.text = status_text

        -- Parse headers
        for line in headers_content:gmatch("[^\r\n]+") do
          local key, value = line:match("^(.-):%s*(.*)$")
          if key and value then
            headers[key] = value
          end
        end

        -- Parse body
        body = output:sub(header_end + 1)
      end
    end

    --- @type vim.NetResult
    state.result = {
      body = body,
      headers = headers,
      ok = ok,
      error = error,
      status = status,
      url = url,
    }

    if opts.on_exit then
      opts.on_exit(state.result)
    end
  end

  state.handle = _run_curl(url, curl_opts, opts, on_exit)

  return new_netobj(state)
end

local M = {}

--- @param url string
--- @param path string
--- @param opts vim.NetOpts
function M.download(url, path, opts)
    return _http_download(url, path, opts)
end
---
--- @param url string
--- @param path string
--- @param opts vim.NetOpts
function M.upload(url, path, opts)
    return _http_upload(url, path, opts)
end

--- @param url string
--- @param opts vim.NetOpts
function M.request(url, opts)
    return _http_request(url, opts)
end

return M
