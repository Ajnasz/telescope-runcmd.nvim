(local commands (require "runcmd.command"))
(fn new-displayer []
  "creates a new displayer for telescope that displays the name and description of a command"
  (local entry_display (require :telescope.pickers.entry_display))
  (entry_display.create
    {
     :separator " | "
     :items [ { :width 30 } { :remaining true } ]
     }
    ))

(fn make-display [displayer]
  "creates a telescope display for a command"
  (fn [entry]
    (displayer
      [(. entry :name) (. entry :description)])))

(fn entry-maker [entry]
  "creates a new entry for telescope"
  (local new_entry (if (= "string" (type entry))
    (commands.new-str-command entry entry "" "")
    entry
    ))
  (tset new_entry :display (make-display (new-displayer)))
  new_entry
  )

(fn get-command-selection [prompt-bufnr]
  "gets the selected command from telescope"
  (let [
        action_state (require :telescope.actions.state)
        selection (action_state.get_selected_entry prompt-bufnr)
        ]

    (?. selection :value)
    ))
(fn execute-commands [prompt-bufnr]
  "executes the selected command in telescope"
  (let [
        cmd (get-command-selection prompt-bufnr)
        ]

    (if cmd
      (let [ actions (require :telescope.actions) ]
        (actions.close prompt-bufnr)

        (vim.cmd.stopinsert)
        ; (fix-telescope-cursor-position picker_mode)
        (vim.schedule #(let [(ok? err) (pcall cmd)]
                         (when (not ok?)
                           (vim.notify err vim.log.levels.ERROR))))
        true)
      (vim.notify "No command selected" vim.log.levels.WARN))))

(fn new-finder [opts]
  "creates a new finder for telescope"
  (let [
        tables (require "runcmd.tables")
        command (require "runcmd.command")
        entry-maker (or (?. opts :entry_maker) entry-maker)
        finders (require :telescope.finders)
        ]

    (finders.new_table
      {
       :results (tables.map
                  command.new_command_from_object
                  (or (?. opts :results) []))
       :entry_maker entry-maker
       })))

(fn new-mappings []
  "creates new mappings for telescope"
  (fn [prompt_bufnr _]
    (let [actions (require :telescope.actions)]
      (actions.select_default:replace #(execute-commands prompt_bufnr))
      true)
    )
  )

(fn open [opts]
  "creates a new picker for telescope"
  (let [
        pickers (require :telescope.pickers)
        conf (. (require :telescope.config) :values)
        picker (pickers.new
                 opts
                 {
                  :prompt_title (or (?. opts :prompt_title) "Execute Command")
                  :finder (new-finder opts)
                  :sorter (conf.generic_sorter opts)
                  :attach_mappings (new-mappings)
                  })
        ]
    (picker:find))
  )


{ :open open }
