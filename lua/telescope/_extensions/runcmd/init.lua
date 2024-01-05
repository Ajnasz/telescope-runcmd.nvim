local telescope = require("telescope")
local runcmd = require("runcmd")
print("register runcmd")
local function _1_(opts)
  return opts
end
local function _2_()
  return runcmd.custom_picker({})
end
return telescope.register_extension({setup = _1_, exports = {runcmd = _2_}})
