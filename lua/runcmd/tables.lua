local function map(cmd, tbl)
  local tbl_21_ = {}
  local i_22_ = 0
  for _, v in ipairs(tbl) do
    local val_23_ = cmd(v)
    if (nil ~= val_23_) then
      i_22_ = (i_22_ + 1)
      tbl_21_[i_22_] = val_23_
    else
    end
  end
  return tbl_21_
end
local function merge(...)
  local output = {}
  for _, tbl in ipairs({...}) do
    do
      local o = output
      for _0, v in ipairs(tbl) do
        table.insert(o, v)
        o = o
      end
    end
    output = output
  end
  return output
end
return {map = map, merge = merge}
