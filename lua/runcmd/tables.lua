local function map(cmd, tbl)
  local tbl_18_auto = {}
  local i_19_auto = 0
  for _, v in ipairs(tbl) do
    local val_20_auto = cmd(v)
    if (nil ~= val_20_auto) then
      i_19_auto = (i_19_auto + 1)
      do end (tbl_18_auto)[i_19_auto] = val_20_auto
    else
    end
  end
  return tbl_18_auto
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
