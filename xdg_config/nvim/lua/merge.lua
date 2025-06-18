local bit = require('bit')
--- based on: https://github.com/Alloyed/ltrie/blob/master/ltrie/lua_hashcode.lua
local function hashkey_from_obj(obj)
  local obj_type = type(obj)
  if obj_type == "boolean" then
    return obj and 1 or 0
  elseif obj_type == "string" then
    local len = #obj
    local hash = len
    local step = bit.rshift(len, 5) + 1
    for i = len, step, -step do
      hash = bit.bxor(hash, bit.lshift(hash, 5) + bit.rshift(hash, 2) + string.byte(obj, i))
    end
    return hash
  elseif obj_type == "table" then
    local hash = vim.islist(obj) and #obj or 51
    for k, v in pairs(obj) do
      hash = bit.bxor(hash, bit.lshift(hash, 7) + bit.rshift(hash, 3) + hashkey_from_obj(k) + hashkey_from_obj(v))
    end
    return hash
  end

  return 0
end

--- @class vim.MergeOpts
--- @field recursive? boolean
--- @field listlike? "merge"|"overwrite"|"concat"|"union"
--- @field eq_func? fun(table, table): boolean

--- @type fun(a: table, b: table, opts: vim.MergeOpts): table
local function merge_values(a, b, opts)
  local function can_merge_as_lists(la, lb)
    return vim.islist(la) and #la > 0 and vim.islist(lb) and #lb > 0
  end

  local function list_overwrite(la, lb)
    if not opts.recursive then
      return vim.deepcopy(lb)
    end

    local ret = {}
    for i = 1, math.max(#la, #lb) do
      table.insert(ret, lb[i] or la[i])
    end
    return ret
  end

  local function list_merge(la, lb)
    local ret = {}
    for i = 1, math.max(#la, #lb) do
      table.insert(ret, opts.recursive
        and merge_values(la[i], lb[i] or la[i], opts)
        or vim.deepcopy(lb[i] or la[i]))
    end
    return ret
  end

  local function list_concat(la, lb)
    if not opts.recursive then
      return vim.list_extend(vim.deepcopy(la), vim.deepcopy(lb))
    end

    local ret = {}
    for i = 1, #la do
      if type(la[i]) == "table" and type(lb[i]) == "table" then
        table.insert(ret, merge_values(la[i], lb[i], opts))
      else
        table.insert(ret, la[i])
      end
    end
    for i = 1, #lb do
      if not la[i] or type(la[i]) ~= "table" or type(lb[i]) ~= "table" then
        table.insert(ret, lb[i])
      end
    end
    return ret
  end

  local function list_union(la, lb)
    local seen = vim.defaulttable()
    return vim.iter(list_concat(la, lb))
      :filter(function(o)
        local key = hashkey_from_obj(o)
        for _, seen_obj in ipairs(seen[key]) do
          if opts.eq_func(o, seen_obj) then
            return false
          end
        end
        table.insert(seen[key], o)
        return true
      end)
      :totable()
  end

  if can_merge_as_lists(a, b) then
    if opts.listlike == "overwrite" then
      return list_overwrite(a, b)
    elseif opts.listlike == "merge" then
      return list_merge(a, b)
    elseif opts.listlike == "concat" then
      return list_concat(a, b)
    elseif opts.listlike == "union" then
      return list_union(a, b)
    else
      error("unknown 'listlike' option: " .. opts.listlike)
    end
  elseif type(a) == "table" and type(b) == "table" then
    local ret = vim.deepcopy(a)
    for k, v in pairs(b) do
      ret[k] = opts.recursive and merge_values(ret[k], v, opts) or vim.deepcopy(v)
    end
    return ret
  else
    return b or a
  end
end

--- @param tables table[]
--- @param opts vim.MergeOpts
--- @return table
local function merge(tables, opts)
  opts = opts or {}
  opts.listlike = opts.listlike or "merge"
  opts.eq_func = opts.eq_func or vim.deep_equal
  local ret = {}

  for _, tbl in ipairs(tables) do
    ret = merge_values(ret, tbl, opts)
  end

  return ret
end

-- Tests and helpers
local function table_to_string(tbl)
  return vim.inspect(tbl):gsub("%s", "")
end

local function run_test(test_name, merge_opts, expected, ...)
  local actual = merge({...}, merge_opts)
  local actual_str = table_to_string(actual)
  local expected_str = table_to_string(expected)
  if actual_str == expected_str then
    print(test_name .. ": PASS")
  else
    print(test_name .. ": FAIL", "Expected:", expected_str, "Actual:", actual_str)
  end
end

local function test_merge_flat_lists()
  local t1 = { 1, 2, 3 }
  local t2 = { 3, 4, 5 }
  local expected_overwrite = { 3, 4, 5 }
  run_test("merge_flat_lists - overwrite", { listlike = 'overwrite' }, expected_overwrite, t1, t2)
  run_test("merge_flat_lists - overwrite - recursive", { listlike = 'overwrite', recursive = true }, expected_overwrite, t1, t2)

  local expected_concat = { 1, 2, 3, 3, 4, 5 }
  run_test("merge_flat_lists - concat", { listlike = 'concat' }, expected_concat, t1, t2)
  run_test("merge_flat_lists - concat - recursive", { listlike = 'concat', recursive = true }, expected_concat, t1, t2)

  local expected_union = { 1, 2, 3, 4, 5 }
  run_test("merge_flat_lists - union", { listlike = 'union' }, expected_union, t1, t2)
  run_test("merge_flat_lists - union - recursive", { listlike = 'union', recursive = true }, expected_union, t1, t2)
end

local function test_merge_nested_lists()
  local t1 = { { 1, 2, 3, 4 }, { 1, 2, 3, 4 }, { 1, 2 } }
  local t2 = { { 3, 4, 5 }, { 3, 4, 5 } }
  local expected_overwrite = { { 3, 4, 5 }, { 3, 4, 5 } }
  run_test("merge_nested_lists - overwrite", { listlike = 'overwrite' }, expected_overwrite, t1, t2)
  local expected_overwrite_recursive = { { 3, 4, 5 }, { 3, 4, 5 }, { 1, 2 } }
  run_test("merge_nested_lists - overwrite - recursive", { listlike = 'overwrite', recursive = true }, expected_overwrite_recursive, t1, t2)

  local expected_concat = { { 1, 2, 3, 4 }, { 1, 2, 3, 4 }, { 1, 2 }, { 3, 4, 5 }, { 3, 4, 5 } }
  run_test("merge_nested_lists - concat", { listlike = 'concat' }, expected_concat, t1, t2)
  local expected_concat_recursive = { { 1, 2, 3, 4, 3, 4, 5 }, { 1, 2, 3, 4, 3, 4, 5 }, { 1, 2 } }
  run_test("merge_nested_lists - concat - recursive", { listlike = 'concat', recursive = true }, expected_concat_recursive, t1, t2)

  local expected_merge = { { 3, 4, 5 }, { 3, 4, 5 }, { 1, 2 } }
  run_test("merge_nested_lists - merge", { listlike = 'merge' }, expected_merge, t1, t2)
  local expected_merge_recursive = { { 3, 4, 5, 4 }, { 3, 4, 5, 4 }, { 1, 2 } }
  run_test("merge_nested_lists - merge - recursive", { listlike = 'merge', recursive = true }, expected_merge_recursive, t1, t2)

  local expected_union = { { 1, 2, 3, 4 }, { 1, 2 }, { 3, 4, 5 } }
  run_test("merge_nested_lists - union", { listlike = 'union' }, expected_union, t1, t2)
  local expected_union_recursive = { { 1, 2, 3, 4, 5 }, { 1, 2 } }
  run_test("merge_nested_lists - union - recursive", { listlike = 'union', recursive = true }, expected_union_recursive, t1, t2)

  local t3 = { { 3, 4, 5 }, { 3, 4, 5 } }
  local t4 = { { 1, 2, 3, 4 }, { 1, 2, 3, 4 }, { 1, 2 } }
  local expected_overwrite2 = { { 1, 2, 3, 4 }, { 1, 2, 3, 4 }, { 1, 2 } }
  run_test("merge_nested_lists - overwrite2", { listlike = 'overwrite' }, expected_overwrite2, t3, t4)
  local expected_overwrite2_recursive = { { 1, 2, 3, 4 }, { 1, 2, 3, 4 }, { 1, 2 } }
  run_test("merge_nested_lists - overwrite2 - recursive", { listlike = 'overwrite', recursive = true }, expected_overwrite2_recursive, t3, t4)

  local expected_concat2 = { { 3, 4, 5 }, { 3, 4, 5 }, { 1, 2, 3, 4 }, { 1, 2, 3, 4 }, { 1, 2 } }
  run_test("merge_nested_lists - concat2", { listlike = 'concat' }, expected_concat2, t3, t4)
  local expected_concat2_recursive = { { 3, 4, 5, 1, 2, 3, 4 }, { 3, 4, 5, 1, 2, 3, 4 }, { 1, 2 } }
  run_test("merge_nested_lists - concat2 - recursive", { listlike = 'concat', recursive = true }, expected_concat2_recursive, t3, t4)

  local expected_merge2 = { { 1, 2, 3, 4 }, { 1, 2, 3, 4 }, { 1, 2 } }
  run_test("merge_nested_lists - merge2", { listlike = 'merge' }, expected_merge2, t3, t4)
  local expected_merge2_recursive = { { 1, 2, 3, 4 }, { 1, 2, 3, 4 }, { 1, 2 } }
  run_test("merge_nested_lists - merge2 - recursive", { listlike = 'merge', recursive = true }, expected_merge2_recursive, t3, t4)

  local expected_union2 = { { 3, 4, 5 }, { 1, 2, 3, 4 }, { 1, 2 } }
  run_test("merge_nested_lists - union2", { listlike = 'union' }, expected_union2, t3, t4)
  local expected_union2_recursive = { { 3, 4, 5, 1, 2 }, { 1, 2 } }
  run_test("merge_nested_lists - union2 - recursive", { listlike = 'union', recursive = true }, expected_union2_recursive, t3, t4)
end

local function test_merge_tables()
  local t1 = { a = 1, b = 2 }
  local t2 = { a = 3, c = 4 }
  local expected_flat = { a = 3, b = 2, c = 4 }
  run_test("merge_tables flat", {}, expected_flat, t1, t2)
  local expected_flat_recursive = { a = 3, b = 2, c = 4 }
  run_test("merge_tables flat recursive", { recursive = true }, expected_flat_recursive, t1, t2)

  local t3 = { a = 1, b = { x = 1, y = 4 } }
  local t4 = { a = "1", b = { x = 3 } }
  local expected_nested = { a = "1", b = { x = 3 } }
  run_test("merge_tables nested", {}, expected_nested, t3, t4)
  local expected_nested_recursive = { a = "1", b = { x = 3, y = 4 } }
  run_test("merge_tables nested recursive", { recursive = true }, expected_nested_recursive, t3, t4)

  local t5 = {}
  local t6 = { a = { b = 1, c = 3 } }
  local expected_empty = { a = { b = 1, c = 3 } }
  run_test("merge_tables empty", {}, expected_empty, t5, t6)
  run_test("merge_tables empty inverse", {}, expected_empty, t6, t5)
end

vim.cmd.message("clear")
test_merge_flat_lists()
test_merge_nested_lists()
test_merge_tables()
