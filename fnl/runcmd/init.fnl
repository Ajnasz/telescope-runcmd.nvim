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

(fn map [cmd tbl]
  (accumulate
    [ o [] _ v (ipairs tbl) ]
    (do (table.insert o (cmd v)) o)))

(fn new-fn-command [name cmd description]
  {
  :name name
  :value cmd
  :ordinal name
  :description description
  })

(fn new-str-command [name cmd description]
  {
  :name name
  :value #(vim.cmd cmd)
  :ordinal name
  :description cmd
  })

(fn new-command [name cmd description]
  (if (= "string" (type cmd))
    (new-str-command name cmd description)
    (new-fn-command name cmd description)))

(fn new-command-from-obj [obj]
  (new-command (. obj :name) (. obj :cmd) (. obj :description)))

(fn new-displayer []
  (local entry_display (require :telescope.pickers.entry_display))
  (entry_display.create
    {
     :separator " | "
     :items [ { :width 30 } { :remaining true } ]
     }
    ))

(fn make-display [displayer]
  (fn [entry]
    (displayer
      [(. entry :name) (. entry :description)])))

(fn entry-maker [entry]
  (local new_entry (if (= "string" (type entry))
    (new-str-command entry entry "" "")
    entry
    ))
  (tset new_entry :display (make-display (new-displayer)))
  new_entry
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
    (local curpos (vim.fn.getpos "."))
    (let [(ok? err) (pcall cmd)]
      (when (not ok?)
        (vim.notify err vim.log.levels.ERROR)))
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
        (map new-command-from-obj (merge-tables
          (or vim.g.runcmd_commands [])
          (or vim.w.runcmd_commands [])
          (or vim.b.runcmd_commands [])
          (or (. (or opts {}) :results) []))))

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


