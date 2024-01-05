(local telescope (require :telescope))
(local runcmd (require :runcmd))

(print "register runcmd")

(telescope.register_extension
  {
   :setup (fn [opts] opts)
   :exports { :runcmd (fn [] (runcmd.custom_picker {})) }
   })
