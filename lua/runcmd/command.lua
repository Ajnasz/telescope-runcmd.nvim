local function new_fn_command(name, cmd, description)
  return {name = name, value = cmd, ordinal = name, description = description}
end
local function new_str_command(name, cmd, description)
  local function _1_()
    return vim.cmd(cmd)
  end
  return {name = name, value = _1_, ordinal = name, description = cmd}
end
local function new_command(name, cmd, description)
  if ("string" == type(cmd)) then
    return new_str_command(name, cmd, description)
  else
    return new_fn_command(name, cmd, description)
  end
end
local function new_command_from_object(obj)
  return new_command(obj.name, obj.value, obj.description)
end
return {new_fn_command = new_fn_command, new_str_command = new_str_command, new_command = new_command, new_command_from_object = new_command_from_object}
