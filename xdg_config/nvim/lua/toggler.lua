-- TODO: check this solution - https://github.com/folke/snacks.nvim/blob/main/docs/toggle.md
---@alias ToggleStatus {buffer:string,global:string,off:string}

local M = {
  ---@type table<string,ToggleStatus?>
  _toggles = {}
}

---@param name string
---@param status? ToggleStatus
function M.set(name, status)
  M._toggles[name] = status
end

---@param name string
---@param enable boolean
---@param buf? number
M.enable = function(name, enable, buf)
  if enable == nil then
    enable = true
  end
  if buf then
    vim.b[buf][name] = enable
  else
    vim.g[name] = enable
    vim.b[vim.api.nvim_get_current_buf()][name] = nil
  end

  vim.notify(name .. ' toggled: ' .. (enable and 'ON' or 'OFF'))
end

---@param name string
---@param buf? number
M.enabled = function(name, buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local gaf = vim.g[name]
  local baf = vim.b[buf][name]

  if baf ~= nil then
    return baf
  end

  return gaf ~= nil and gaf
end

---@param name string
---@param buf? number
M.toggle = function(name, buf)
  M.enable(name, not M.enabled(name, buf), buf)
end

function M.status()
  local statuses = {}
  for name, status in pairs(M._toggles) do
    if status ~= nil then
      local buf_toggle = vim.b[vim.api.nvim_get_current_buf()][name]

      if buf_toggle ~= nil then
        statuses[#statuses + 1] = (buf_toggle and status.buffer or status.off)
      else
        statuses[#statuses + 1] = (vim.g[name] and status.global or status.off)
      end
    end
  end

  return table.concat(statuses, ' | ')
end

return M
