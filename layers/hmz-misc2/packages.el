(defconst hmz-misc2-packages
  '(;;all-the-icons
    doom-modeline
    google-this
    yascroll))

;; (defun hmz-misc2/init-all-the-icons ()
;;   (straight-use-package 'all-the-icons))

(defun hmz-misc2/init-doom-modeline ()
  (use-package doom-modeline
    :straight t
    ;; :if window-system
    :ensure t
    ;; :defer 2
    ;; :requires all-the-icons
    :config
    (doom-modeline-mode 1)
    ;; The maximum displayed length of the branch name of version control.
    (setq doom-modeline-vcs-max-length 34)
    (setq doom-modeline-height 18)))

(defun hmz-misc2/init-yascroll ()
  (use-package yascroll
    :straight t
    :config
    (global-yascroll-bar-mode 1)))

(defun hmz-misc2/init-google-this ()
  (use-package google-this
    :straight t
    :config (google-this-mode 1)
    ))

;;; packages.el ends here
