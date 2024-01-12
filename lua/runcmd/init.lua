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
  print("callopen", opts)
  return runcmdpicker.open(opts)
end
return {open = open}
