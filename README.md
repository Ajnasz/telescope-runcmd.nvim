# RunCMD Telescope extension

![runcmd](https://github.com/Ajnasz/telescope-runcmd.nvim/assets/38329/d2007ad3-6935-4bf1-961d-d53f735a77ba)

## Usage

The extension loads commands from `vim.g.runcmd_commands`,
`vim.w.runcmd_commands` and `vim.b.runcmd_commands`.
A command must have a `name` property, which will be displayed in the telescope
window. A `cmd` property which will be executed when the item selected and an
optional `description` which will be also displayed in the telescope window
next to the name.

A `cmd` can be a lua function or a user command as string.

To open the configured commands, use `:Telescope runcmd` command.

With the `FileType` autocommand you can add commands only for specific filetypes by adding commands to `vim.b.runcmd_commands`.

You can use the `require("runcmd.picker").open({ results = { ... }})` to open the picker with any command.

For more see the examples below

## Examples

```lua
local runcmd = require("runcmd")
local telescope = require("telescope")

-- general wrapper to put string to the cursor
function insert_at_cursor(lines)
  return vim.api.nvim_put(lines, "", false, true)
end

-- function to insert the current date to the cursor with the given format
function insert_date_str(format)
  return insert_at_cursor({vim.fn.strftime(format)})
end

-- insert uuid to the cursor position
function insert_uuid()
  return insert_at_cursor(vim.fn.systemlist("uuid | tr -d '\n'"))
end


vim.api.nvim_create_user_command("UUID", insert_uuid, {})

-- global commands
vim.g.runcmd_commands = {
    -- lua function command
    { name = "UUID", cmd = insert_uuid, description = "Insert UUID" },
    { name = "Date", cmd = function() insert_date_str("%Y-%m-%d") end, description = "Insert date" },
    { name = "Time", cmd = function() insert_date_str("%H-%M-%S") end, description = "Insert time" },
    { name = "Date Time", cmd = function() insert_date_str("%Y-%d-%m %H-%M-%S") end, description = "Insert date time" },
    -- predefined user command (vim-fugitive)
    { name = "Git", cmd = "Git", description = "Open Git" },
    -- subcommands
    {
        name = "Lsp ->",
        cmd = function()
            local picker = require('runcmd.picker')
            picker.open({
                results = {
                    { name = "Start LSP", cmd = "LspStart", description = "start lsp" },
                    { name = "Stop LSP", cmd = "LspStop" , description = "stop lsp" },
                    { name = "LSP Info", cmd = "LspInfo" , description = "lsp info" },
                },
            })
        end,
        description = "Language Server commands",
    },
}

-- commands for specific filetype
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {"ledger"},
    callback = function()
        vim.b.runcmd_commands = {
            {
                name = "Align Buffer",
                cmd = "LedgerAlignBuffer",
                description = "Aligns the commodity for each posting in the entire buffer",
            },
        }
    end
})
telescope.load_extension("runcmd")

-- map to hotkey key <leader>cmd
vim.keymap.set("n", "<leader>cmd", ":Telescope runcmd<cr>", {buffer = true})
```
