if _G._editorconfig_omnifunc == nil then
  local completion_table_map = {
    root = {
      compl_item = {
        word = "root =",
        abbr = "root",
        menu = "[property]",
        info = "Defines the top-most EditorConfig file",
      },
      values = {
        { word = "true", menu = "[value]" },
        { word = "false", menu = "[value]" },
      },
    },
    indent_style = {
      compl_item = { word = "indent_style =", abbr = "indent_style", menu = "[property]", info = "Indentation Style" },
      values = {
        { word = "tab", menu = "[value]" },
        { word = "space", menu = "[value]" },
      },
    },
    indent_size = {
      compl_item = { word = "indent_size =", abbr = "indent_size", menu = "[property]", info = "Indentation Size" },
      values = {
        { word = "tab", menu = "[value]" },
      },
    },
    tab_width = {
      compl_item = {
        word = "tab_width =",
        abbr = "tab_width",
        menu = "[property]",
        info = "Width of a single tabstop character",
      },
      values = {},
    },
    end_of_line = {
      compl_item = {
        word = "end_of_line =",
        abbr = "end_of_line",
        menu = "[property]",
        info = "Line ending file format",
      },
      values = {
        { word = "lf", menu = "[value]" },
        { word = "crlf", menu = "[value]" },
        { word = "cr", menu = "[value]" },
      },
    },
    charset = {
      compl_item = { word = "charset =", abbr = "charset", menu = "[property]", info = "File character encoding" },
      values = {
        { word = "latin1", menu = "[value]" },
        { word = "utf-8", menu = "[value]" },
        { word = "utf-16be", menu = "[value]" },
        { word = "utf-16le", menu = "[value]" },
        { word = "utf-8-bom", menu = "[value]" },
      },
    },
    trim_trailing_whitespace = {
      compl_item = {
        word = "trim_trailing_whitespace =",
        abbr = "trim_trailing_whitespace",
        menu = "[property]",
        info = "Denotes whether whitespace is removed from the end of lines",
      },
      values = {
        { word = "true", menu = "[value]" },
        { word = "false", menu = "[value]" },
      },
    },
    insert_final_newline = {
      compl_item = {
        word = "insert_final_newline =",
        abbr = "insert_final_newline",
        menu = "[property]",
        info = "Denotes whether file should end with a newline",
      },
      values = {
        { word = "true", menu = "[value]" },
        { word = "false", menu = "[value]" },
      },
    },
    max_line_length = {
      compl_item = {
        word = "max_line_length =",
        abbr = "max_line_length",
        menu = "[property]",
        info = "Forces hard line wrapping after the amout of characters specified",
      },
      values = {
        { word = "unset", menu = "[value]" },
      },
    },
    spelling_language = {
      compl_item = {
        word = "spelling_language =",
        menu = "[property]",
        info = "A code of the format ss or ss-TT, where ss is an ISO 639 language code and TT is an ISO 3166 territory identifier",
      },
      values = {},
    },
  }
  _G._editorconfig_omnifunc = function(findstart, base)
    if findstart == 1 then
      local line = vim.fn.getline(".")
      local start = line:find("%S+$") or vim.fn.col(".")
      vim.b.compl_context = line
      return start - 1
    end

    local line = vim.b.compl_context
    local first_word = line:match("(%S+)") or ""
    local matches = {}
    for name, property in pairs(completion_table_map) do
      if first_word == name and line:find("=%s*$") then
        return property.values
      end
      if first_word == base and name:find(base) then
        table.insert(matches, property.compl_item)
      end
    end

    return matches
  end
end

vim.bo.omnifunc = "v:lua._editorconfig_omnifunc"
