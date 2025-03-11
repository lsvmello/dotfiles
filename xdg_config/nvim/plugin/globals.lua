function I(...)
  print(unpack(vim.tbl_map(vim.inspect, { ... })))
end

