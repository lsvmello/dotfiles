local M = {}

M.statusline_filename = require("lualine.component"):extend()

function M.statusline_filename:format(text, hl_group)
  text = text:gsub("%%", "%%%%")
  if not hl_group or hl_group == "" then
    return text
  end
  self.hl_cache = self.hl_cache or {}
  local lualine_hl_group = self.hl_cache[hl_group]
  if not lualine_hl_group then
    local utils = require("lualine.utils.utils")
    ---@type string[]
    local gui = vim.tbl_filter(function(x)
      return x
    end, {
      utils.extract_highlight_colors(hl_group, "bold") and "bold",
      utils.extract_highlight_colors(hl_group, "italic") and "italic",
    })

    lualine_hl_group = self:create_hl({
      fg = utils.extract_highlight_colors(hl_group, "fg"),
      gui = #gui > 0 and table.concat(gui, ",") or nil,
    }, "CUSTOM_" .. hl_group) --[[@as string]]
    self.hl_cache[hl_group] = lualine_hl_group
  end
  return self:format_hl(lualine_hl_group) .. text .. self:get_default_hl()
end

function M.statusline_filename:update_status()
    local path = vim.fn.expand("%:p:~") --[[@as string]]

    local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")
    local cwd_dir = self:format(cwd, "Directory")

    local swap_indicator = ""
    if path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 1)
    elseif path ~= "" then
      swap_indicator = self:format("   ", "MatchParen")
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]")

    if vim.bo.modified then
      parts[#parts] = self:format(parts[#parts], "MatchParen")
    else
      parts[#parts] = self:format(parts[#parts], "Bold")
    end

    local dir = ""
    if #parts > 1 then
      dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep)
      dir = self:format(dir .. sep, "")
    end

    local readonly = ""
    if vim.bo.readonly then
      readonly = self:format(" 󰌾", "MatchParen")
    end

    return cwd_dir .. swap_indicator .. dir .. parts[#parts] .. readonly
end

M.winbar_filename = require("lualine.components.filename"):extend()

function M.winbar_filename:update_status()
  -- TODO: when filename has protocol it should display everything
  -- maybe I should take the code from the original filename component
  local original_status = M.winbar_filename.super.update_status(self)
  if vim.wo.previewwindow then
    return "[PREVIEW] " .. original_status
  end
  return original_status
end

return M
