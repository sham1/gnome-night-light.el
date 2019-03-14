gnome-night-light.el
====================

A package which integrates with the Night Light-feature of your GNOME desktop.

Usage example
--------------

Changing theme according to the time of day.

```
(defun theme-changer (state)
  (if state
	  (my/set-dark-theme)
    (my/set-light-theme)))

(require 'gnome-night-light)
(setq gnome-night-light/light-change-callback #'theme-changer)
(gnome-night-light)
```

The callback passed to gnome-night-light has to accept a boolean variable.
This variable is `t` when the night light is active.

License
-------

GPLv3+
