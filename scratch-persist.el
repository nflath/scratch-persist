;;; scratch-persist.el --- persist the scratch buffer across sessions

;; Copyright (C) 2013 Nathaniel Flath <nflath@gmail.com>

;; Author: Nathaniel Flath <nflath@gmail.com>
;; URL: http://github.com/nflath/scratch-persist
;; Version: 1.1

;; This file is not part of GNU Emacs.

;;; Commentary:

;;; This package makes the scratch buffer persistent across sessions (as well as within session)

;;; Installation:

;; To install, put this file somewhere in your load-path and add the following
;; to your .emacs file:
;; (require 'scratch-persist)

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:


(defvar scratch-persist-file "~/.emacs.d/scratch.el"
  "Location the *scratch* buffer is saved to.")

(defun scratch-persist-mode ()
  (interactive)
  (save-excursion
    (set-buffer (get-buffer-create "*scratch*"))
    (lisp-interaction-mode)
 ;;; Prevent the *scratch* buffer from ever being killed
    (make-local-variable 'kill-buffer-query-functions)
    (add-hook 'kill-buffer-query-functions #'(lambda ()
                                               (if (eq (current-buffer) (get-buffer-create "*scratch*"))
                                                   (bury-buffer)
                                                 (bury-buffer (get-buffer-create "*scratch*")))
                                               nil))
 ;;; Reload the *scratch* buffer from file
    (erase-buffer)
    (if (file-exists-p scratch-persist-file) (insert-file scratch-persist-file))
    (setq buffer-file-name scratch-persist-file)
    (setq default-directory "~/.emacs.d")
    (save-buffer)))
(scratch-persist-mode)

(provide 'scratch-persist)
;;; scratch-persist.el ends here
