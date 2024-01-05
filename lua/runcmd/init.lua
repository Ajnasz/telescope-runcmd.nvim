local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = (require("telescope.config")).values
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
local function entry_maker(entry)
  if ("string" == type(entry)) then
    return __fnl_global__new_2dstr_2dcommand(entry, entry)
  else
    return entry
  end
end
local function execute_commands(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local selection = action_state.get_selected_entry(prompt_bufnr)
  local cmd = selection.value
  actions.close(prompt_bufnr)
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
  return finders.new_table({results = (((opts or {})).results or {}), entry_maker = entry_maker0})
end
local function new_mappings()
  local function attach_mappings(prompt_bufnr, _)
    local function _3_()
      return execute_commands(prompt_bufnr)
    end
    do end (actions.select_default):replace(_3_)
    return true
  end
  return attach_mappings
end
local function custom_command_picker(opts)
  (opts or {})["results"] = merge_tables((vim.g.custom_commands or {}), (vim.w.custom_commands or {}), (vim.b.custom_commands or {}), (((opts or {})).results or {}))
  local picker = pickers.new(opts, {prompt_title = "Execute Command", finder = new_finder(opts), sorter = conf.generic_sorter(opts), attach_mappings = new_mappings()})
  return picker:find()
end
local function new_fn_command(name, cmd)
  return {display = name, value = cmd, ordinal = name}
end
local function new_str_command(name, cmd)
  local function _4_()
    return vim.cmd(cmd)
  end
  return {display = name, value = _4_, ordinal = name}
end
local function new_command(name, cmd)
  if ("string" == type(cmd)) then
    return new_str_command(name, cmd)
  else
    return new_fn_command(name, cmd)
  end
end
local function esc()
  return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "ni", false)
end
return {custom_picker = custom_command_picker, new_command = new_command, new_str_command = new_str_command, new_fn_command = new_fn_command, esc = esc, merge_tables = merge_tables}
