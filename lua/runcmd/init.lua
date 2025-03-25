local function open(opts)
  local tables = require("runcmd.tables")
  local _2_
  do
    local t_1_ = opts
    if (nil ~= t_1_) then
      t_1_ = t_1_.results
    else
    end
    _2_ = t_1_
  end
  do end (opts or {})["results"] = tables.merge((vim.g.runcmd_commands or {}), (vim.w.runcmd_commands or {}), (vim.b.runcmd_commands or {}), (_2_ or {}))
  local runcmdpicker = require("runcmd.picker")
  print("callopen", opts)
  return runcmdpicker.open(opts)
end
return {open = open}
