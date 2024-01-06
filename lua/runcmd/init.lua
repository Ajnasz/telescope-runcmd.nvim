local function merge_tables(...)
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
local function new_fn_command(name, cmd)
  return {display = name, value = cmd, ordinal = name}
end
local function new_str_command(name, cmd)
  local function _1_()
    return vim.cmd(cmd)
  end
  return {display = name, value = _1_, ordinal = name}
end
local function new_command(name, cmd)
  if ("string" == type(cmd)) then
    return new_str_command(name, cmd)
  else
    return new_fn_command(name, cmd)
  end
end
local function entry_maker(entry)
  if ("string" == type(entry)) then
    return new_str_command(entry, entry)
  else
    return entry
  end
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
  do
    local ok_3f, err = pcall(cmd)
    if (err and not (err == "")) then
      vim.notify(err, vim.log.levels.ERROR)
    else
    end
  end
  return true
end
local function new_finder(opts)
  local entry_maker0 = (((opts or {})).entry_maker or entry_maker)
  local finders = require("telescope.finders")
  return finders.new_table({results = (((opts or {})).results or {}), entry_maker = entry_maker0})
end
local function new_mappings()
  local function attach_mappings(prompt_bufnr, _)
    local actions = require("telescope.actions")
    local function _6_()
      return execute_commands(prompt_bufnr)
    end
    do end (actions.select_default):replace(_6_)
    return true
  end
  return attach_mappings
end
local function custom_command_picker(opts)
  (opts or {})["results"] = merge_tables((vim.g.custom_commands or {}), (vim.w.custom_commands or {}), (vim.b.custom_commands or {}), (((opts or {})).results or {}))
  local pickers = require("telescope.pickers")
  local conf = (require("telescope.config")).values
  local picker = pickers.new(opts, {prompt_title = "Execute Command", finder = new_finder(opts), sorter = conf.generic_sorter(opts), attach_mappings = new_mappings()})
  return picker:find()
end
local function esc()
  return vim.cmd.stopinsert()
end
return {custom_picker = custom_command_picker, new_command = new_command, new_str_command = new_str_command, new_fn_command = new_fn_command, esc = esc, merge_tables = merge_tables}
