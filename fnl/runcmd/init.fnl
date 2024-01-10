(fn open [opts]
  "creates a new picker for telescope that displays the commands in vim.g.runcmd_commands, vim.w.runcmd_commands, vim.b.runcmd_commands, and opts.results"
  (local tables (require "runcmd.tables"))
  (tset (or opts {}) :results
        (tables.merge
          (or vim.g.runcmd_commands [])
          (or vim.w.runcmd_commands [])
          (or vim.b.runcmd_commands [])
          (or (?. opts :results) [])))

  (local runcmdpicker (require "runcmd.picker"))

  (runcmdpicker.open { :results (or (?. opts :results) []) })
  )

(fn esc [] (vim.cmd.stopinsert))

{
 :open open
 :esc esc
 }
