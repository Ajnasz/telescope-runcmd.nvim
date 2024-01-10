local function open(opts)
  local tables = require("runcmd.tables")
  local function _1_(...)
    local t_2_ = opts
    if (nil ~= t_2_) then
      t_2_ = t_2_.results
    else
    end
    return t_2_
  end
  do end ((opts or {}))["results"] = tables.merge((vim.g.runcmd_commands or {}), (vim.w.runcmd_commands or {}), (vim.b.runcmd_commands or {}), (_1_() or {}))
  local runcmdpicker = require("runcmd.picker")
  local function _4_(...)
    local t_5_ = opts
    if (nil ~= t_5_) then
      t_5_ = t_5_.results
    else
    end
    return t_5_
  end
  return runcmdpicker.open({results = (_4_() or {})})
end
local function esc()
  return vim.cmd.stopinsert()
end
return {open = open, esc = esc}
