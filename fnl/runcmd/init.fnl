(local actions (require :telescope.actions))
(local action_state (require :telescope.actions.state))
(local finders (require :telescope.finders))
(local pickers (require :telescope.pickers))
(local conf (. (require :telescope.config) :values))

(fn merge-tables [...]
  (accumulate
    [ output [] _ tbl (ipairs [...]) ]
    (do
      (accumulate
        [ o output _ v (ipairs tbl) ]
        (do
          (table.insert o v) o))
      output)
    )
  )

(fn new-fn-command [name cmd] {
  :display name
  :value cmd
  :ordinal name
  })

(fn new-str-command [name cmd] {
  :display name
  :value #(vim.cmd cmd)
  :ordinal name
  })

(fn new-command [name cmd]
  (if (= "string" (type cmd))
    (new-str-command name cmd)
    (new-fn-command name cmd)))

(fn entry-maker [entry]
  (if (= "string" (type entry))
    (new-str-command entry entry)
    entry
    )
  )

(fn execute-commands [prompt-bufnr]
  (let [
        picker (action_state.get_current_picker prompt-bufnr)
        selection (action_state.get_selected_entry prompt-bufnr)
        cmd (. selection :value)
        ]
    (actions.close prompt-bufnr)
    (let [(ok? err) (pcall cmd)]
      (when (and err (not (= err ""))) (vim.notify err vim.log.levels.ERROR)))
    true
  ))

(fn new-finder [opts]
  (local entry-maker (or (. (or opts {}) :entry_maker) entry-maker))
  (finders.new_table
    {
     :results (or (. (or opts {}) :results) [])
     :entry_maker entry-maker
     }))

(fn new-mappings []
  (fn attach-mappings [prompt_bufnr _]
    (actions.select_default:replace #(execute-commands prompt_bufnr))
    true)
  )

(fn custom-command-picker [opts]
  (tset (or opts {}) :results (merge-tables
                (or vim.g.custom_commands [])
                (or vim.w.custom_commands [])
                (or vim.b.custom_commands [])
                (or (. (or opts {}) :results) [])))

  (local picker (pickers.new opts
               {:prompt_title "Execute Command"
                :finder (new-finder opts)
                :sorter (conf.generic_sorter opts)
                :attach_mappings (new-mappings)
                }))
  (picker:find)
  )

(fn esc [] (vim.api.nvim_feedkeys (vim.api.nvim_replace_termcodes "<esc>" true false true) "ni" false))
{
 :custom_picker custom-command-picker
 :new_command new-command
 :new_str_command new-str-command
 :new_fn_command new-fn-command
 :esc esc
 :merge_tables merge-tables
 }


