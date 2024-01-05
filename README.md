# RunCMD Telescope extension

![runcmd](https://github.com/Ajnasz/runcmd.nvim/assets/38329/c447ed71-b0e3-4759-ad31-249ccf22ebe8)

Examples

```lua
local runcmd = require("runcmd")
local telescope = require("telescope")

function insert_at_cursor(lines)
  return vim.api.nvim_put(lines, "c", false, true)
end
function insert_date_str(format)
  return insert_at_cursor({vim.fn.strftime(format)})
end
function insert_date()
  return insert_date_str("%Y-%m-%d")
end
function insert_time()
  return insert_date_str("%H:%M:%S")
end
function insert_date_time()
  return insert_date_str("%Y-%m-%d %H:%M:%S")
end
function insert_uuid()
  return insert_at_cursor(vim.fn.systemlist("uuid | tr -d '\n'"))
end
function insert_objectid()
  return insert_at_cursor(vim.fn.systemlist("objectid | tr -d '\n'"))
end
function insert_something()
  return insert_at_cursor({"something"})
end

vim.api.nvim_create_user_command("ObjectId", insert_objectid, {})
vim.api.nvim_create_user_command("UUID", insert_uuid, {})
vim.api.nvim_create_user_command("Something", insert_something, {})

vim.g.custom_commands = {
    runcmd.new_command("UUID", insert_uuid),
    runcmd.new_command("Something", insert_something),
    runcmd.new_command("Insert date", insert_date),
    runcmd.new_command("Insert time", insert_time),
    runcmd.new_command("Insert date-time", insert_date_time),
}

telescope.load_extension("runcmd")

vim.keymap.set("n", "<leader>cmd", ":Telescope runcmd<cr>", {buffer = true})
```
