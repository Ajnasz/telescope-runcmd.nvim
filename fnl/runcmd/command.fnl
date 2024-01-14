(fn new-fn-command [name cmd description]
  "creates a new command that executes the given function"
  {
  :name name
  :value cmd
  :ordinal name
  :description description
  })

(fn new-str-command [name cmd description]
  "creates a new command that executes the given string as a vim command"
  {
  :name name
  :value #(vim.cmd cmd)
  :ordinal name
  :description cmd
  })

(fn new-command [name cmd description]
  "creates a new command that executes the given string or function as a vim command, see new-str-command and new-fn-command"
  (if (= "string" (type cmd))
    (new-str-command name cmd description)
    (new-fn-command name cmd description)))

(fn new-command-from-object [obj]
  "creates a new command from the given object"
  (new-command (. obj :name) (. obj :cmd) (. obj :description)))

{
:new_fn_command new-fn-command
:new_str_command new-str-command
:new_command new-command
:new_command_from_object new-command-from-object
}
