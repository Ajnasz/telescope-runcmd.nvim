# RunCMD Telescope extension

![runcmd](https://github.com/Ajnasz/telescope-runcmd.nvim/assets/38329/d2007ad3-6935-4bf1-961d-d53f735a77ba)

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

function insert_uuid()
  return insert_at_cursor(vim.fn.systemlist("uuid | tr -d '\n'"))
end
function insert_objectid()
  return insert_at_cursor(vim.fn.systemlist("objectid | tr -d '\n'"))
end
function insert_something()
  return insert_at_cursor({"something"})
end

vim.api.nvim_create_user_command("UUID", insert_uuid, {})
vim.api.nvim_create_user_command("Something", insert_something, {})

-- global commands
vim.g.runcmd_commands = {
    { name = "UUID", cmd = insert_uuid, description = "Insert UUID" },
    { name = "Something", cmd = insert_something, description = "Insert Something" },
    { name = "Git", cmd = "Git", description = "Open Git" },
}

-- command for specific filetype
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {"ledger"},
    callback = function()
        vim.b.runcmd_commands = {
            { name = "Align Buffer", cmd = "LedgerAlignBuffer", description = "Aligns the commodity for each posting in the entire buffer" },
        }
    end
})
telescope.load_extension("runcmd")

vim.keymap.set("n", "<leader>cmd", ":Telescope runcmd<cr>", {buffer = true})
```
