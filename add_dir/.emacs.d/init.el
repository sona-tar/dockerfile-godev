(defvar user-emacs-directory (concat (getenv "HOME") "/.emacs.d"))
(add-to-list 'load-path (concat user-emacs-directory "plugin"))
(require 'gtags)
