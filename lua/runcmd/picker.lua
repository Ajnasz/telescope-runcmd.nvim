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
local function fix_telescope_cursor_position(picker_mode)
  local cursor_valid, original_cursor = pcall(vim.api.nvim_win_get_cursor, 0)
  if (cursor_valid and ("i" == vim.api.nvim_get_mode().mode) and not ("i" == picker_mode)) then
    return pcall(vim.api.nvim_win_set_cursor, 0, {original_cursor[1], (original_cursor[2] - 1)})
  else
    return nil
  end
end
local function execute_commands(prompt_bufnr)
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")
  local picker = action_state.get_current_picker(prompt_bufnr)
  local selection = action_state.get_selected_entry(prompt_bufnr)
  local cmd = selection.value
  local picker_mode = picker._original_mode
  actions.close(prompt_bufnr)
  vim.cmd.stopinsert()
  fix_telescope_cursor_position(picker_mode)
  local curpos = vim.fn.getpos(".")
  do
    local ok_3f, err = pcall(cmd)
    if not ok_3f then
      vim.notify(err, vim.log.levels.ERROR)
    else
    end
  end
  return true
end
local function new_finder(opts)
  local tables = require("runcmd.tables")
  local command = require("runcmd.command")
  local entry_maker0
  local function _5_(...)
    local t_6_ = opts
    if (nil ~= t_6_) then
      t_6_ = t_6_.entry_maker
    else
    end
    return t_6_
  end
  entry_maker0 = (_5_() or entry_maker)
  local finders = require("telescope.finders")
  local function _8_(...)
    local t_9_ = opts
    if (nil ~= t_9_) then
      t_9_ = t_9_.results
    else
    end
    return t_9_
  end
  return finders.new_table({results = tables.map(command.new_command_from_obj, (_8_() or {})), entry_maker = entry_maker0})
end
local function new_mappings()
  local function attach_mappings(prompt_bufnr, _)
    local actions = require("telescope.actions")
    local function _11_()
      return execute_commands(prompt_bufnr)
    end
    do end (actions.select_default):replace(_11_)
    return true
  end
  return attach_mappings
end
local function open(opts)
  local pickers = require("telescope.pickers")
  local conf = require("telescope.config").values
  local picker
  local function _12_(...)
    local t_13_ = opts
    if (nil ~= t_13_) then
      t_13_ = t_13_.prompt_title
    else
    end
    return t_13_
  end
  picker = pickers.new(opts, {prompt_title = (_12_() or "Execute Command"), finder = new_finder(opts), sorter = conf.generic_sorter(opts), attach_mappings = new_mappings()})
  return picker:find()
end
return {open = open}
