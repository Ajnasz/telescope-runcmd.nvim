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
    (new-str-command entry entry "" "")
    entry
    ))
  (tset new_entry :display (make-display (new-displayer)))
  new_entry
  )

(fn fix-telescope-cursor-position [picker_mode]
  "fixes the cursor position after executing a command in telescope. This is necessary because telescope moves the cursor to the end of the line after executing a command."
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
  "executes the selected command in telescope"
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
                  command.new_command_from_obj
                  (or (?. opts :results) []))
       :entry_maker entry-maker
       })))

(fn new-mappings []
  "creates new mappings for telescope"
  (fn attach-mappings [prompt_bufnr _]
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
