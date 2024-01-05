(local telescope (require :telescope))
(local runcmd (require :runcmd))

(telescope.register_extension
  {
   :setup (fn [opts] opts)
   :exports { :runcmd (fn [] (runcmd.custom_picker {})) }
   })
