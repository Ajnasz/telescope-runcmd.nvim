local function map(cmd, tbl)
  local o = {}
  for _, v in ipairs(tbl) do
    table.insert(o, cmd(v))
    o = o
  end
  return o
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
