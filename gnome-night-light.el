;;; gnome-night-light.el --- Provides integration with the Night Light feature of GNOME

;; Copyright (C) 2019 Jani Juhani Sinervo

;; Author: Jani Juhani Sinervo <jani@sinervo.fi>
;; Created: 14 Mar 2019
;; Version: 1.0
;; Keywords: gnome
;; URL: https://github.com/sham1/gnome-night-light.el

;; This file is NOT part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; gnome-night-light.el is a simple way to have Emacs integrate with
;; your GNOME desktop's Night Light feature.  This can be used for instance
;; to change your theme from a light theme to a dark one and vice versa
;; depending on the time of day, while leveraging the location information
;; of GNOME.

;;; Code:

(eval-when-compile
  (require 'dbus))

(defvar gnome-night-light/light-change-callback nil
  "The callback function called on Night Light state change.
It takes one parameter, which is t when the Night Light is active
\(e.g.  it's night) and nil when it's day.")

(defun gnome-night-light/internal-prop-change-listener (name changed-props _)
  (let* ((prop (car changed-props))
	 (name (car prop))
	 (value (car (cadr prop))))
    (when (string-equal name "NightLightActive")
      (when (functionp gnome-night-light/light-change-callback)
	(funcall gnome-night-light/light-change-callback value)))))

(defun gnome-night-light ()
  "Load and enable gnome-night-light."
  (dbus-register-signal
   :session
   "org.gnome.SettingsDaemon.Color"
   "/org/gnome/SettingsDaemon/Color"
   "org.freedesktop.DBus.Properties"
   "PropertiesChanged"
   #'gnome-night-light/internal-prop-change-listener)
  (let ((value (dbus-get-property
		:session
		"org.gnome.SettingsDaemon.Color"
		"/org/gnome/SettingsDaemon/Color"
		"org.gnome.SettingsDaemon.Color"
		"NightLightActive")))
    (when (functionp gnome-night-light/light-change-callback)
      (funcall gnome-night-light/light-change-callback value))))

(provide 'gnome-night-light)
;;; gnome-night-light.el ends here
