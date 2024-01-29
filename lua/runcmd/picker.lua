local function new_displayer()
  local entry_display = require("telescope.pickers.entry_display")
  return entry_display.create({separator = " | ", items = {{width = 30}, {remaining = true}}})
end
local function make_display(displayer)
  local function _1_(entry)
    return displayer({entry.name, entry.description})
  end
  return _1_
end
local function entry_maker(entry)
  local new_entry
  if ("string" == type(entry)) then
    new_entry = __fnl_global__new_2dstr_2dcommand(entry, entry, "", "")
  else
    new_entry = entry
  end
  new_entry["display"] = make_display(new_displayer())
  return new_entry
end
local function get_command_selection(prompt_bufnr)
  local action_state = require("telescope.actions.state")
  local selection = action_state.get_selected_entry(prompt_bufnr)
  local t_3_ = selection
  if (nil ~= t_3_) then
    t_3_ = t_3_.value
  else
  end
  return t_3_
end
local function execute_commands(prompt_bufnr)
  local cmd = get_command_selection(prompt_bufnr)
  if cmd then
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local picker = action_state.get_current_picker(prompt_bufnr)
    local picker_mode = picker._original_mode
    actions.close(prompt_bufnr)
    vim.cmd.stopinsert()
    local curpos = vim.fn.getpos(".")
    local function _5_()
      local ok_3f, err = pcall(cmd)
      if not ok_3f then
        return vim.notify(err, vim.log.levels.ERROR)
      else
        return nil
      end
    end
    vim.schedule(_5_)
    return true
  else
    return vim.notify("No command selected", vim.log.levels.WARN)
  end
end
local function new_finder(opts)
  local tables = require("runcmd.tables")
  local command = require("runcmd.command")
  local entry_maker0
  local function _8_(...)
    local t_9_ = opts
    if (nil ~= t_9_) then
      t_9_ = t_9_.entry_maker
    else
    end
    return t_9_
  end
  entry_maker0 = (_8_() or entry_maker)
  local finders = require("telescope.finders")
  local function _11_(...)
    local t_12_ = opts
    if (nil ~= t_12_) then
      t_12_ = t_12_.results
    else
    end
    return t_12_
  end
  return finders.new_table({results = tables.map(command.new_command_from_object, (_11_() or {})), entry_maker = entry_maker0})
end
local function new_mappings()
  local function attach_mappings(prompt_bufnr, _)
    local actions = require("telescope.actions")
    local function _14_()
      return execute_commands(prompt_bufnr)
    end
    do end (actions.select_default):replace(_14_)
    return true
  end
  return attach_mappings
end
local function open(opts)
  local pickers = require("telescope.pickers")
  local conf = require("telescope.config").values
  local picker
  local function _15_(...)
    local t_16_ = opts
    if (nil ~= t_16_) then
      t_16_ = t_16_.prompt_title
    else
    end
    return t_16_
  end
  picker = pickers.new(opts, {prompt_title = (_15_() or "Execute Command"), finder = new_finder(opts), sorter = conf.generic_sorter(opts), attach_mappings = new_mappings()})
  return picker:find()
end
return {open = open}
