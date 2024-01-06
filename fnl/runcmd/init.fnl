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

(fn fix-telescope-cursor-position [picker_mode]
  (let [(cursor_valid original_cursor) (pcall vim.api.nvim_win_get_cursor 0)]
    (when
      (and
        cursor_valid
        (= "i" (. (vim.api.nvim_get_mode) :mode))
        (not (= "i" picker_mode)))
      (pcall
        vim.api.nvim_win_set_cursor 0 [ (. original_cursor 1) (- (. original_cursor 2) 1) ])
      )
    )
  )

(fn execute-commands [prompt-bufnr]
  (let [
        action_state (require :telescope.actions.state)
        actions (require :telescope.actions)
        picker (action_state.get_current_picker prompt-bufnr)
        selection (action_state.get_selected_entry prompt-bufnr)
        cmd (. selection :value)
        picker_mode picker._original_mode
        ]

    (actions.close prompt-bufnr)

    (vim.cmd.stopinsert)
    (fix-telescope-cursor-position picker_mode)
    (let [(ok? err) (pcall cmd)]
      (when (and err (not (= err ""))) (vim.notify err vim.log.levels.ERROR)))
    true
    ))

(fn new-finder [opts]
  (let [
        entry-maker (or (. (or opts {}) :entry_maker) entry-maker)
        finders (require :telescope.finders)
        ]
    (finders.new_table
      {
       :results (or (. (or opts {}) :results) [])
       :entry_maker entry-maker
       })))

(fn new-mappings []
  (fn attach-mappings [prompt_bufnr _]
    (let [actions (require :telescope.actions)]
      (actions.select_default:replace #(execute-commands prompt_bufnr))
      true)
    )
  )

(fn custom-command-picker [opts]
  (tset (or opts {}) :results
        (merge-tables
          (or vim.g.custom_commands [])
          (or vim.w.custom_commands [])
          (or vim.b.custom_commands [])
          (or (. (or opts {}) :results) [])))

  (let [
        pickers (require :telescope.pickers)
        conf (. (require :telescope.config) :values)
        picker (pickers.new
                 opts
                 {
                  :prompt_title "Execute Command"
                  :finder (new-finder opts)
                  :sorter (conf.generic_sorter opts)
                  :attach_mappings (new-mappings)
                  })
        ]
    (picker:find))
  )

(fn esc [] (vim.cmd.stopinsert))

{
 :custom_picker custom-command-picker
 :new_command new-command
 :new_str_command new-str-command
 :new_fn_command new-fn-command
 :esc esc
 :merge_tables merge-tables
 }


