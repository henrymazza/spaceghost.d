(defconst hmz-misc-packages
  ;; default behavior is to install from melpa.org
  '(
    ;; company-posframe
    ;; direx
    ;; highlight-indent-guides
    hl-block-mode
    ;; indicators
    ;; ivy-posframe
    ;; psession
    ;; undohist
    ;; which-key-posframe
    alert
    all-the-icons
    amx
    bpr
    centaur-tabs
    circe
    dired-sidebar
    doom-modeline
    doom-todo-ivy
    ember-mode
    evil-ruby-text-objects
    fira-code-mode
    gcmh
    google-this
    hide-lines
    hydra-posframe
    ibuffer-projectile
    ibuffer-sidebar
    indent-guide
    list-processes
    neotree
    persp-mode
    persp-mode-projectile-bridge
    ;; restore-frame-position
    ri
    rspec-simple
    rubocopfmt
    sublimity
    switch-buffer-functions
    tempbuf
    wakatime-mode
    yascroll
    ))


(defun hmz-misc/init-doom-modeline ()
  (use-package doom-modeline
    :straight t
    ;; :if window-system
    ;; :defer 2
    ;; :requires all-the-icons
    :config
    (doom-modeline-mode 1)
    ;; The maximum displayed length of the branch name of version control.
    (setq doom-modeline-vcs-max-length 34)
    (setq doom-modeline-height 18)))

(defun hmz-misc/init-yascroll ()
  (use-package yascroll
    :straight t
    :config
    (global-yascroll-bar-mode 1)))

(defun hmz-misc/init-google-this ()
  (use-package google-this
    :straight t
    :config (google-this-mode 1)))

(defun hmz-misc/init-hydra-posframe ()
 (use-package hydra-posframe
   :straight (hydra-posframe :type git :host github :repo "Ladicle/hydra-posframe")
   :requires (posframe hydra)
   ;; :load-path "<path-to-the-hydra-posframe>"
   :hook (after-init . hydra-posframe-enable)))

(defun hmz-misc/post-init-projectile-rails ()
  ;; FIXME: i'm not running
  ;; temporary fix for void auto-insert-alist / Not working?
  (use-package projectile-rails
    :straight t
    :config
    ;; Fix for projectile rails breaking helm buffers
    (defun projectile-rails--setup-auto-insert ()
      "Call `define-auto-insert' with condition for ruby files under the current project.

If `auto-insert-alist' holds already the condition for the current project it does nothing.
So it safe to call it many times like in a minor mode hook."
      (let* ((file-re (format "^%s.*\\.rb$" (projectile-rails-root)))
             (current-project-cond `(,file-re . "projectile-rails")))
        (unless (and (boundp 'auto-insert-alist)
                     (projectile-rails--auto-insert-setup-p current-project-cond))
          (define-auto-insert
            current-project-cond
            [
             (lambda () (insert (projectile-rails-corresponding-snippet)))
             projectile-rails-expand-yas-buffer
             ]
            ))))))

(defun hmz-misc/init-circe ()
  (straight-use-package 'circe))

(defun hmz-misc/init-all-the-icons ()
  (straight-use-package 'all-the-icons))

(defun hmz-misc/init-ibuffer-projectile ()
  (use-package ibuffer-projectile
    :straight t
    :commands (ibuffer-projectile-set-filter-groups
               ibuffer-projectile-generate-filter-groups)
    :init
    (defun j-ibuffer-projectile-run ()
      "Set up `ibuffer-projectile'."
      (ibuffer-projectile-set-filter-groups)
      (unless (eq ibuffer-sorting-mode 'recency)
        (ibuffer-do-sort-by-alphabetic)))

    (add-hook 'ibuffer-sidebar-mode-hook #'j-ibuffer-projectile-run)
    (add-hook 'ibuffer-hook #'j-ibuffer-projectile-run)
    :config
    (setq ibuffer-projectile-prefix "")))

(defun hmz-misc/init-ibuffer-sidebar ()
  (use-package ibuffer-sidebar
    :straight t
    :load-path "~/.emacs.d/fork/ibuffer-sidebar"
    :commands (ibuffer-sidebar-toggle-sidebar)
    :config
    (setq ibuffer-sidebar-use-custom-font t)) )

(defun hmz-misc/init-which-key-posframe ()
  (use-package which-key-posframe
    :straight t
    :load-path "path/to/which-key-posframe.el"
    :init
    (setq which-key-posframe-poshandler 'posframe-poshandler-window-top-center)
    :config
    (which-key-posframe-mode)))

(defun hmz-misc/init-ivy-posframe ()
  (use-package ivy-posframe
    :straight t
    :init
    ;; display at `ivy-posframe-style'
    (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display)))
    (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center)))
    (ivy-posframe-mode 1)
    ))

(defun hmz-misc/init-company-posframe ()
  (use-package company-posframe
    :straight t
    :config
    (company-posframe-mode)))

(defun hmz-misc/init-psession ()
  (use-package psession
    :straight t
    :config
    (psession-mode 1)))

(defun hmz-misc/init-undohist ()
  (use-package undohist
    :straight t
    :demand
    :init
    (undohist-initialize)))

(defun hmz-misc/init-ibuffer-sidebar ()
  (use-package ibuffer-sidebar
    ;; :load-path "~/.emacs.d/fork/ibuffer-sidebar"
    :commands (ibuffer-sidebar-toggle-sidebar)
    :config
    (setq ibuffer-sidebar-use-custom-font t)
    (setq ibuffer-sidebar-face `(:family "San Francisco" :height 120)
    (spacemacs/set-leader-keys "b B" 'ibuffer-sidebar-toggle-sidebar)
    (setq ibuffer-default-sorting-mode 'recency)
    (setq ibuffer-sidebar-use-custom-font t)
    (add-hook 'ibuffer-sidebar-mode-hook #'j-ibuffer-projectile-run))))

(defun hmz-misc/init-dired-sidebar ()
  (use-package dired-sidebar
    :straight t
    :commands (dired-sidebar-toggle-sidebar)))

(defun hmz-misc/init-centaur-tabs ()
  (use-package centaur-tabs
    :straight t
    ;; :defer t
    ;; only load if hmz-tabbar isn't config's part
    :unless (member 'hmz-tabbar dotspacemacs-configuration-layers)
    :init
    (setq centaur-tabs-set-icons t)
    (setq centaur-tabs-plain-icons nil)
    (setq centaur-tabs-gray-out-icons 'buffer)
    (setq centaur-tabs-gray-out-icons nil)
    (setq centaur-tabs-set-bar 'over)
    (setq centaur-tabs-set-bar 'under)
    (setq centaur-tabs-set-bar 'under)
    (setq centaur-tabs-set-close-button nil)
    (setq centaur-tabs-set-modified-marker t)
    (setq centaur-tabs--buffer-show-groups nil)
    (setq centaur-tabs-cycle-scope 'tabs)
    (setq centaur-tabs-show-navigation-buttons nil)
    (setq centaur-tabs-show-navigation-buttons t)
    (setq centaur-tabs-adjust-buffer-order t)
    (setq centaur-tabs-background-color "black")
    (setq centaur-tabs-plain-icons nil)
    (setq centaur-tabs-set-icons t)
    (setq centaur-tabs-set-left-close-button nil)
    (setq centaur-tabs-modified-marker "#")

    ;; (set-selection-coding-system 'utf-8)

    :config
    (centaur-tabs-mode 1)
    ;; Safari like key-bindings
    (global-set-key [(control shift tab)] 'centaur-tabs-backward)
    (global-set-key [(control tab)] 'centaur-tabs-forward)))

(defun hmz-misc/init-direx ()
  (use-package direx
    :straight t
    :init))

(defun hmz-misc/init-persp-mode-projectile-bridge ()
  (use-package persp-mode-projectile-bridge
    :straight t
    :after (projectile persp-mode)
    :defer 2
    :init
    (add-hook 'persp-mode-projectile-bridge-mode-hook
        #'(lambda ()
            (if persp-mode-projectile-bridge-mode
                (persp-mode-projectile-bridge-find-perspectives-for-all-buffers)
              (persp-mode-projectile-bridge-kill-perspectives))))

    :config
    (persp-mode-projectile-bridge-mode 1)))

(defun hmz-misc/post-init-persp-mode ()
  (use-package persp-mode
    :straight t
    :requires projectile
    :custom
    (persp-auto-save-num-of-backups 10)
    (persp-autokill-buffer-on-remove 'kill-weak)
    (persp-interactive-completion-system 'ido)
    (persp-keymap-prefix "")
    (persp-nil-name "nil")

    :config
    (persp-def-auto-persp "dotfiles"
        :mode 'prog-mode)

    (persp-def-auto-persp "ruby"
        :buffer-name "\\.rb")

    (persp-def-auto-persp "elisp"
        :buffer-name "\\.el")

    (persp-def-auto-persp "projectile"
        :hooks 'projectile-mode-hook
        :get-name (projectile-project-root)
        :predicate (lambda (buffer state)
               (if (and (not (eq nil (buffer-file-name buffer)))
            (bound-and-true-p projectile-mode)
            (projectile-project-p)
            (projectile-project-buffer-p buffer (projectile-project-root)))
             nil))
        :on-match (lambda (perspective buffer after-match hook args)
              (persp-frame-switch perspective)))))

(defun hmz-misc/init-sublimity ()
    (use-package sublimity
      :straight t
      :init
      (require 'sublimity)
      (require 'sublimity-scroll)
      (require 'sublimity-attractive)
      (setq sublimity-attractive-centering-width 110)
      (sublimity-mode t)))

(defun hmz-misc/init-restore-frame-position ()
  (use-package restore-frame-position
    :straight (restore-frame-position :type git :host github :repo "aaronjensen/restore-frame-position")
    :config
    (restore-frame-position)))

(defun hmz-misc/init-tempbuf ()
  (use-package tempbuf
    :straight t
    ;; :load-path  "~/spacemacs.d/layers/hmz-misc/local/tempbuf/tempbuf.el"
    :config
    ;; modified from jmjeong / jmjeong-emacs
    (add-hook 'help-mode-hook 'turn-on-tempbuf-mode)
    (add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)
    (add-hook 'custom-mode-hook 'turn-on-tempbuf-mode)
    (add-hook 'w3-mode-hook 'turn-on-tempbuf-mode)
    (add-hook 'Man-mode-hook 'turn-on-tempbuf-mode)
    (add-hook 'view-mode-hook 'turn-on-tempbuf-mode)
    (add-hook 'helm-major-mode-hook 'turn-on-tempbuf-mode)
    (add-hook 'fundamental-mode-hook 'turn-on-tempbuf-mode)
    (add-hook 'inferior-python-mode-hook 'turn-on-tempbuf-mode)
    (add-hook 'magit-mode-hook 'turn-on-tempbuf-mode)

    ;; tempbuf by default
    ;; (remove-hook 'find-file-hooks 'turn-on-tempbuf-mode)

    (defun hmz-misc/tempbuf-kill-func ()
       (message "%s" (buffer-name))
       (shell-command
        (combine-and-quote-strings
         (list "terminal-notifier"
     "-message" (buffer-name)
     "-title" "Tempbuf"
     ) " ")))

    (add-hook 'tempbuf-kill-hook 'hmz-misc/tempbuf-kill-func)

    (and (fboundp 'temp-buffer-resize-mode) (temp-buffer-resize-mode t))))

(defun hmz-misc/init-rspec-simple ()
  (use-package rspec-simple
    :straight (rspec-simple :type git :host github :repo "code-mancers/rspec-simple")))

(defun hmz-misc/init-amx ()
  (defun spacemacs/amx ()
    "Execute amx with a better prompt."
    (interactive)
    (let ((amx-prompt-string "Emacs commands: "))
      (amx)))

  (defun spacemacs/amx-major-mode-commands ()
    "Reexecute amx with major mode commands only."
    (interactive)
    (let ((amx-prompt-string (format "%s commands: " major-mode)))
      (amx-major-mode-commands)))

  (use-package amx
    :defer t
    :init
    (progn
      (setq-default amx-history-length 32
                    amx-save-file (concat spacemacs-cache-directory
                                          ".amx-items"))
      ;; define the key binding at the very end in order to allow the user
      ;; to overwrite any key binding
      (add-hook 'emacs-startup-hook
                (lambda () (spacemacs/set-leader-keys
                        dotspacemacs-emacs-command-key 'spacemacs/amx)))
      (spacemacs/set-leader-keys ":" 'spacemacs/amx-major-mode-commands)
      (spacemacs/set-leader-keys "SPC" 'spacemacs/amx)
      (global-set-key (kbd "M-x") 'spacemacs/amx)
      (global-set-key (kbd "M-X") 'spacemacs/amx-major-mode-commands))))

(defun hmz-misc/init-ri ()
  (straight-use-package 'ri))

(defun hmz-misc/init-wakatime-mode ()
  (use-package wakatime-mode
    :straight t
    :init
    (setq wakatime-python-path "/usr/local/bin/python3")
    :config
    (global-wakatime-mode t)))

(defun hmz-misc/init-hl-block-mode ()
  (use-package hl-block-mode
    :straight (hl-block-mode :type git :host github :repo "emacsmirror/hl-block-mode")
    :config
    (global-hl-block-mode t)))

(defun hmz-misc/init-evil-ruby-text-objects ()
  (use-package evil-ruby-text-objects
    :straight t
    :init
    (add-hook 'ruby-mode-hook 'evil-ruby-text-objects-mode)
    (add-hook 'enh-ruby-mode-hook 'evil-ruby-text-objects-mode)))

(defun hmz-misc/init-indent-guide ()
  (use-package indent-guide
    :straight t
    :if window-system
    :init
    (setq indent-guide-delay 0.8)
    (setq indent-guide-char "·")
    (setq indent-guide-threshold 1)

    ;; retard removing highlights so I can find myself after long jumps in big
    ;; blocks
    (defun indent-guide-pre-command-hook ()
      ;; some commands' behavior may affected by indent-guide overlays, so
      ;; remove all overlays in pre-command-hook.
      (run-with-timer 0.4 nil
          (lambda () (indent-guide-remove))))

    (add-hook 'prog-mode-hook
        (lambda() (indent-guide-mode t)))

    (highlight-indent-guides-mode -1)
    (highlight-indentation-mode -1)))

(defun hmz-misc/init-highlight-indent-guides ()
  (use-package highlight-indent-guides
    :straight t
    :init
    (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
    (setq highlight-indent-guides-method 'character)))

(defun hmz-misc/init-doom-todo-ivy ()
  (use-package doom-todo-ivy
    :requires ivy
    :hook (after-init . doom-todo-ivy)
    :load-path "~/.spacemacs.d/layers/hmz-misc/local/doom-todo-ivy/doom-todo-ivy.el"
    :init
    ;; XXX test
    ;; NOTE test
    ;; HACK test
    ;; OPTIMIZE test
    ;; BUG test
    ;; TODO test
    ;; FIXME test
    (setq doom/ivy-task-tags
    '(("HACK" . warning)
      ("OPTIMIZE" . success)
      ("XXX" . font-lock-function-name-face)
      ("NOTE"  . font-lock-variable-name-face)
      ("BUG"  . font-lock-warning-face)
      ("TODO"  . warning)
      ("FIXME" . error)))))

(defun hmz-misc/init-indicators ()
  (use-package indicators
    :straight t
    :config
    (setq ind-indicator-height 19)
    (add-hook 'after-change-major-mode-hook
        (lambda()
    (ind-create-indicator 'point
              :managed t
              :face 'font-lock-const-face)))))

(defun hmz-misc/init-rubocopfmt ()
  (add-to-list 'load-path "~/.spacemacs.d/layers/hmz-misc/local")
  (add-hook 'ruby-mode-hook #'rubocopfmt-mode))

(defun hmz-misc/init-fira-code-mode ()
  (use-package fira-code-mode
    :straight t
    :if window-system
    :load-path "~/.spacemacs.d/layers/hmz-misc/local/fira-code-mode/"
    :hook prog-mode))

(defun hmz-misc/init-gcmh ()
  (use-package gcmh
    :straight t
    :load-path "~/.spacemacs.d/layers/hmz-misc/local/gcmh/"
    :config
    (gcmh-mode 1)))

(defun hmz-misc/init-alert ()
  (use-package alert
    :straight t
    :config
    (alert-add-rule :status   '(buried visible idle)
                :severity '(moderate high urgent)
                :mode     'erc-mode
                :predicate
                #'(lambda (info)
                    (string-match (concat "\\`[^&].*@BitlBee\\'")
                                  (erc-format-target-and/or-network)))
                :persistent
                #'(lambda (info)
                    ;; If the buffer is buried, or the user has been
                    ;; idle for `alert-reveal-idle-time' seconds,
                    ;; make this alert persistent.  Normally, alerts
                    ;; become persistent after
                    ;; `alert-persist-idle-time' seconds.
                    (memq (plist-get info :status) '(buried idle)))
                :style 'fringe
                :continue t)))

(defun hmz-misc/init-list-processes+ ()
  (use-package list-processes+
    :straight t
    :defer t
    :config

    (spacemacs/set-leader-keys "a p" 'list-processes+)

    ;; override this which is broken
    (defun list-processes-kill-process ()
      ""
      (interactive)
      ;; the end of this line use to have 'process, which is void
      (let ((proc (get-text-property (point) 'tabulated-list-id)))
  (when (and proc
       (y-or-n-p (format "Kill process %s? " (process-name proc))))
    (delete-process proc)
    (list-processes+))))))

(defun hmz-misc/init-hide-lines ()
  (use-package hide-lines
    :straight t
    :config
    (add-hook 'after-change-major-mode-hook
        (lambda () (add-to-invisibility-spec 'hl)))))

(defun hmz-misc/init-hidesearch ()
  (straight-use-package 'hidesearch))

(defun hmz-misc/init-bpr ()
  (use-package bpr
    :straight t
    :requires alert
    :config

    (use-package alert
      :config
      (defun hmz-misc/mac-notify (title &optional message)
  (alert message :title title)))

    (defun hmz-misc/bpr-process-sentinel (proc string)
      (if (string-equal string "finished\n")
    (run-with-timer 5 nil (lambda (p)
        (delete-window)
        ) (process-buffer proc))
    (run-with-timer 60 nil (lambda (p)
        (kill-buffer p)
        (message "Killed buffer %s" p)
        ) (process-buffer proc)))
      (alert (process-name proc) :title string))

    (setq my-ansi-escape-re
      (rx (or
    (and (or ?\233 (and ?\e ?\[))
         (zero-or-more (char (?0 . ?\?)))
         (zero-or-more (char ?\s ?- ?\/))
         (char (?@ . ?~)))
    (char "")
    (char ""))))

    (defun hmz-misc/bpr-process-filter (proc string)
      (when (buffer-live-p (process-buffer proc))
  (with-current-buffer (process-buffer proc)
    (let
        ((moving (> 3 (abs (- (count-lines (point-min) (point-max)) (line-number-at-pos))))))

      (save-excursion  ;;TODO perhaps save-mark-and-excursion?

        ;; Insert the text, advancing the process marker.
        (goto-char (process-mark proc))
        ;; (overwrite-mode overwrite-mode-textual)


        (let ((str
         ;; Ember test is throwing escaped \n, hope just now
         (replace-regexp-in-string "\\\\n" "\n" string)))

    (while (string-match my-ansi-escape-re str)
      ;; send first part to the buffer
      (let ((content (substring str 0 (car (match-data)))))
        (insert content)
        (delete-char (min (- (point-max)
           (point))
              (length content))))

      ;; deal with special code
      (let ((ansi-code (substring str  (car (match-data))
                (cadr (match-data)))))

        (condition-case nil
      (cond
       ;;TODO save re context
       ;; Color Code
       ;; ((string-equal "\\n" ansi-code) (insert "\n"))
       ((string-equal "" ansi-code)
        (delete-backward-char 1))
       ((string-equal "" ansi-code)
        (beginning-of-line)
        (kill-line))
       ((string-match-p "m$" ansi-code) (insert ansi-code))

       ((string-match "\\[\\(?1:.*\\);\\(?2:.*\\)f" ansi-code)
        (let ((col (string-to-number (match-string 1 ansi-code)))
        (lin (string-to-number (match-string 2 ansi-code))))
          (goto-char (point-max))
          (while (< (count-lines (point-min) (point-max)) (lin))
            (newline))
          (goto-line lin)

          (end-of-line)
          (while (< (current-column) col)
            (insert " "))
          (beginning-of-line)
          (forward-char col)))

       ((string-match "\\[\\(?1:.*\\)\\(?2:[ABCD]\\)" ansi-code)
        (let ((count (string-to-int
          (match-string 1 ansi-code)))
        (cmd (match-string 2 ansi-code)))

          (cond
           ;;TODO: does up and down command preserve columns(?)
           ;; Moves the cursor up by COUNT rows
           ((string-equal cmd "A")
            (forward-line ;; negative goes back
             (- (min
           count
           (count-lines (point-min)
            (point))))))
           ;; moves the cursor down by COUNT rows
           ((string-equal cmd "B")
            (forward-line count))
           ;; moves the cursor forward by COUNT columns
           ((string-equal cmd "C")
            (forward-char count))
           ;; moves the cursor backward by COUNT columns
           ((string-equal cmd "D")
            (if (> (current-column) count)
          (backward-char count)
        (beginning-of-line))))))

       ;; clear all to the right
       ((string-equal ansi-code "[0K") (kill-line))
       ;; idem
       ((string-equal ansi-code "[K") (kill-line))
       ;; Requests a Report Device Code response from the device. (WTF?)
       ((string-equal ansi-code "[c") nil)
       ;; erase all current line
       ((string-equal ansi-code "[2K") (kill-whole-line))
       ;; erase from cursor to begining of line
       ((string-equal ansi-code "[1K") (kill-backward-chars (- (current-column) 1)))
       ;; clear vertical tabulation (?)
       ((string-equal ansi-code "[1G") (beginning-of-line))
       ;; Show the cursor (duh!)
       ((string-equal ansi-code "[?25h") nil)
       ;; insert unrecognized
       (t (insert (format "[%s]"ansi-code))))
          (error "ERROR: %s" ansi-code))

        ;; process the rest
        (setq str (substring str (cadr (match-data))))))

    ;; insert piece after last code
    (insert str))

        ;;TODO Try to detect errors and such
        (when (string-match-p "Error" string)
    (hmz-misc/mac-notify "Filter got and Error!" string))

        (if (< (process-mark proc) (point))
      (ansi-color-apply-on-region (marker-position (process-mark proc)) (point))
    (ansi-color-apply-on-region (point-min) (marker-position (process-mark proc))))

        (set-marker (process-mark proc) (point)))

      (if moving (goto-char (process-mark proc)))))))

    (defun hmz-misc/bpr-clear-or-kill ()
      "If process is running clear buffer, kills it otherwise."
      (interactive)
      (if (process-live-p (get-buffer-process (current-buffer)))
    (if (zerop (buffer-size))
        (kill-this-buffer)
      (erase-buffer))
  (kill-this-buffer)))

    (defun hmz-misc/bpr-on-error (process)
      (hmz-misc/mac-notify "Error" (process-name process))
      (with-current-buffer (process-buffer process)
  (save-excursion
    (rename-buffer
     (replace-regexp-in-string "\[.*\]" "[ERROR]" (format "%s"(tabbar-tab-value tab)))))))

    (defun hmz-misc/bpr-on-success (process)
      (hmz-misc/mac-notify "Success" (process-name process))
      (with-current-buffer (process-buffer process)
  (save-excursion
    (rename-buffer
     (replace-regexp-in-string "\[.*\]" "[OK]" (buffer-name))))))

    (defun hmz-misc/bpr-on-start (process)

      ;; (setq buffer-face-mode-face `(:background "#111111"))
      ;; (buffer-face-mode 1)
      (switch-to-buffer-other-window (process-buffer process))
      (tabbar-local-mode -1) ;; often it gets hidden, I suppose this helps
      (set-process-filter process 'hmz-misc/bpr-process-filter)
      (set-process-sentinel process 'hmz-misc/bpr-process-sentinel)
      (with-current-buffer (process-buffer process)
  (save-excursion
    (local-set-key  (kbd "s-k") 'hmz-misc/bpr-clear-or-kill)
    (text-scale-decrease 2)
    (setq tab-width 8)
    (setq overwrite-mode 'overwrite-mode-binary)
    (rename-buffer
     (replace-regexp-in-string "\(.*\)" (concat "[" (format "%s" (process-id process)) "]") (buffer-name)))))

      (hmz-misc/mac-notify "Started" (process-name process)))

    (defun hmz-misc/bpr-on-completion (process)
      (hmz-misc/mac-notify (format "Ended with status %d" (process-exit-status process)) (process-name process)))

    (spacemacs/set-leader-keys "a b" 'bpr-spawn)

    (setq bpr-on-error 'hmz-misc/bpr-on-error)
    (setq bpr-on-success 'hmz-misc/bpr-on-success)
    (setq bpr-on-completion 'hmz-misc/bpr-on-completion)
    (setq bpr-on-start 'hmz-misc/bpr-on-start)

    (defun preamble-regexp-alternatives (regexps)
      "Return the alternation of a list of regexps."
      (mapconcat (lambda (regexp)
       (concat "\\(?:" regexp "\\)"))
     regexps "\\|"))

    (defvar non-sgr-control-sequence-regexp nil
      "Regexp that matches non-SGR control sequences.")

    (defun regexp-alternatives (regexps)
      (mapconcat (lambda (regexp) (concat "\\(" regexp "\\)")) regexps "\\|"))

    (setq non-sgr-control-sequence-regexp
    (regexp-alternatives
     '(;; icon name escape sequences
       "\033\\][0-2];.*?\007"
       ;; non-SGR CSI escape sequences
       "\033\\[\\??[0-9;]*[^0-9;m]"
       ;; noop
       "\012\033\\[2K\033\\[1F"
       )))

    (defun filter-non-sgr-control-sequences-in-region (begin end)
      (save-excursion
  (goto-char begin)
  (while (re-search-forward
    non-sgr-control-sequence-regexp end t)
    (message (match-string))
    (replace-match ""))))

    (defun filter-non-sgr-control-sequences-in-output (ignored)
      (let ((start-marker
       (or comint-last-output-start
     (point-min-marker)))
      (end-marker
       (process-mark
        (get-buffer-process (current-buffer)))))
  (filter-non-sgr-control-sequences-in-region
   start-marker
   end-marker)))

    ;; (setq    'comint-output-filter-functions nil  )
    ;; (add-hook 'comint-output-filter-functions
    ;;           'filter-non-sgr-control-sequences-in-output)

    ;; no showing progress on echo line
    (setq bpr-show-progress nil)

    ;; use ansi-color-apply-on-region function on output buffer
    (setq bpr-colorize-output nil)

    ;; use comint-mode for processes output buffers instead of shell-mode
    (setq bpr-process-mode 'shell-mode)

    (setq bpr-scroll-direction -1)
    ;; (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
    ;; (add-hook 'comint-mode-hook 'ansi-color-for-comint-mode-on)

    ;; (add-to-list 'comint-output-filter-functions 'ansi-color-process-output)

    ))

(defun hmz-misc/init-ember-mode ()
  (use-package ember-mode
    :straight t
    :config
    (defun ember--file-project-root (file)
      "Overriden function so it come back to the old behavior and
       search by app dir."
      (locate-dominating-file file "app"))

    (add-hook 'coffee-mode-hook (lambda () (ember-mode t)))
    (add-hook 'js-mode-hook (lambda () (ember-mode t)))
    (add-hook 'web-mode-hook (lambda () (ember-mode t)))))

(defun hmz-misc/init-switch-buffer-functions ()
    (use-package switch-buffer-functions
      :straight t
      :config
      (setq switch-buffer-functions nil)
      (add-hook 'switch-buffer-functions
    (lambda (prev cur)
      (unless (or (string= (buffer-name) "*Messages*")
         (string= (buffer-name) neo-buffer-name))
        (if (and (not hmz-neotree-hidden) (buffer-file-name))
      (neotree-refresh t)

          (neotree-hide)))))))

(defun hmz-misc/init-indicators ()
  (use-package indicators
    :straight t
    :config
    (add-hook 'prog-mode
        (lambda ()
    (ind-create-indicator
     'point
     :managed t)))))

(defun hmz-misc/post-init-neotree ()
  (use-package neotree
    :straight t
    :defer t
    :requires (all-the-icons rainbow-identifiers)
    :init
    ;; I'm leaving most of these settings to customize
    (setq neo-auto-indent-point t)
    (setq neo-autorefresh nil)

    ;; hide line number in Neotree buffer
    (display-line-numbers-mode nil)
    (linum-mode nil)

    ;;TODO: it crawls to a death in big dirs, going to bet on refreshing on
    ;;      buffer change. Possibly adding a timeout for it to occur.
    (setq neo-banner-message "")
    (setq neo-create-file-auto-open t)
    (setq neo-filepath-sort-function (lambda (f1 f2) (string< (downcase f1)
                    (downcase f2))))

    (setq neo-vc-integration (quote (face char)))
    (setq neo-force-change-root t)
    (setq neo-show-hidden-files t)
    (setq neo-show-updir-line nil)
    (setq neo-smart-open t)
    (setq neo-theme (if (display-graphic-p) (quote icons) (quote arrow)))
    (setq neo-window-fixed-size nil)
    (setq neo-window-position (quote right))

    :config
    (defun hmz-winum-assign-func ()
      (cond
       ((equal (buffer-name) "*Calculator*")
  10)
       ((string-match-p (buffer-name) ".*\\*NeoTree\\*.*")
  9)
       (t
  nil)))

    (setq winum-assign-func 'hmz-winum-assign-func)


    (defun neo-buffer--insert-dir-entry (node depth expanded)
      "Overriden function to get rid of useless typography."
      (let ((node-short-name (neo-path--file-short-name node)))
        (insert
         (propertize " "
                     'display `(space :width ,(* 2 (- depth 1)) )))

        (when (memq 'char neo-vc-integration)

          (insert
           (propertize " "
                       'display `(space :width 0.35))))

        (neo-buffer--insert-fold-symbol
         (if expanded 'open 'close) node)
        (insert-button (concat node-short-name "")
                       'follow-link t
                       'face neo-dir-link-face
                       'neo-full-path node
                       'keymap neotree-dir-button-keymap
                       'help-echo
                       (neo-buffer--help-echo-message node-short-name))
        (neo-buffer--node-list-set nil node)
        (neo-buffer--newline-and-begin)))

    (setq hmz-misc/neo-sort-dir-with-files t)

    (defun neo-buffer--insert-tree (path depth)
      (if (eq depth 1)
          (neo-buffer--insert-root-entry path))
      (let* ((contents (neo-buffer--get-nodes path))
             (nodes (car contents))
             (leafs (cdr contents))
             (default-directory path))

        (if (> (length nodes) 100)
            (insert " ··· \n")
          (if (bound-and-true-p hmz-misc/neo-sort-dir-with-files)
              (let ((sorted (sort
                             (append (car contents) (cdr contents))
                             (lambda (s1 s2)
                               (string< (upcase s1) (upcase s2) )))))
                (dolist (node sorted)
                  (if (file-directory-p node)
                      (let ((expanded (neo-buffer--expanded-node-p node)))
                        (neo-buffer--insert-dir-entry
                         node depth expanded)
                        (if expanded (neo-buffer--insert-tree (concat node "/")
                                                              (+ depth 1))))

                    (neo-buffer--insert-file-entry node depth))))

            (dolist (node nodes)
              (let ((expanded (neo-buffer--expanded-node-p node)))
                (neo-buffer--insert-dir-entry
                 node depth expanded)
                (if expanded (neo-buffer--insert-tree (concat node "/")
                                                      (+ depth 1)))))
            (dolist (leaf leafs)
              (neo-buffer--insert-file-entry leaf depth))))))


    (defun neo-buffer--insert-file-entry (node depth)
      "Overriden so it can be configured to show files and directories together."

      (let ((node-short-name (neo-path--file-short-name node))
            (vc (when neo-vc-integration (neo-vc-for-node node))))


        (insert
         (propertize " "
                     'display `(space :width ,(+ 0.3 (* 2 (- depth 1))))))

        (neo-buffer--insert-fold-symbol 'leaf node-short-name)

        (insert-button node-short-name
                       'follow-link t
                       'face neo-file-link-face
                       'neo-full-path node
                       'keymap neotree-file-button-keymap
                       'help-echo (neo-buffer--help-echo-message node-short-name))
        (neo-buffer--node-list-set nil node)
        (neo-buffer--newline-and-begin)))

    (defun neo-buffer--insert-fold-symbol (name &optional node-name)
      "Overriden to make it less noisy. Made to work with non-monospaced fonts."
      (let ((vc (when neo-vc-integration (neo-vc-for-node node)))
            (n-insert-symbol (lambda (n)
                               (neo-buffer--insert-with-face
                                n 'neo-expand-btn-face))))
        (cond
         ((and (display-graphic-p) (equal neo-theme 'icons))

          (or (and (equal name 'open)
                   (insert
                    (propertize
                     " "
                     'display '((raise 0)
                                (space :width 0.0)))
                    (propertize
                     (all-the-icons-octicon "triangle-down")
                     'face `(:family ,(all-the-icons-octicon-family) :foreground "skyblue" :height 1.2)
                     'display '(raise -0.0))
                    (propertize
                     " "
                     'display '((raise 0)
                                (space :width 0.3)))))

              (and (equal name 'close)
                   (insert

                    (propertize
                     " "
                     'display '((raise 0.00)
                                (space :width 0.50)))
                    (propertize
                     (all-the-icons-octicon "triangle-right")
                     'face `(:family ,(all-the-icons-octicon-family) :foreground  "grey40" :height 1.2 )
                     'display '(raise 0.0))

                    (propertize
                     " "
                     'display '((raise 0)
                                (space :width 0.5)))))

              (and (equal name 'leaf)
                   (if vc
                       (let ((vc-string (char-to-string (car vc))))

                         (insert (propertize vc-string
                                             'display '(height 0.80)
                                             'face (if (memq 'face neo-vc-integration)
                                                       (cdr vc)
                                                     neo-file-link-face)))
                         (if (string-equal vc-string " ")
                             (insert
                              (propertize " " 'display '(space :width 0.90)))
                           (insert (propertize " " 'display '(space :width 0.70)))))

                     (insert
                      (propertize " "
                                  'display `(space :width 1.00))))



                   )))
         (t
          (or (and (equal name 'open)  (funcall n-insert-symbol "▼ "))
              (and (equal name 'close) (funcall n-insert-symbol "► ")))))))

    (defun neo-opens-outwards ()
      "Reveals Neotree expanding frame and tries to compensate internal size."
      (interactive)
      (if (neo-global--window-exists-p)
          (progn
            (setq hmz-neotree-hidden t)
            (neotree-hide))

        (let ((origin-buffer-file-name (buffer-file-name)))
          (setq hmz-neotree-hidden nil)
          (neotree-find (projectile-project-root))
          (neotree-find origin-buffer-file-name))))

    (global-set-key (kbd "s-r") 'neo-opens-outwards)
    (global-set-key (kbd "H-r") 'neo-opens-outwards)

    (defun hmz-neotree-mode-hook ()
      ;; (face-remap-add-relative 'default :background-color "blue")
      ;; (set-background-color "black")
      ;; (setq buffer-face-mode-face `(:background "red"))

      (hidden-mode-line-mode t)

      ;; custom doesn't work, neither does setting on init file
      (setq neo-buffer--show-hidden-file-p nil)

      ;; hide cursor when not active
      (setq cursor-in-non-selected-windows nil)

      ;; no scroll bars
      (scroll-bar-mode 0)

      ;; highlight current line
      (hl-line-mode t)
      ;; hl-line-mode when window not in focus
      (setq hl-line-sticky-flag t)

      ;; disable fringes
      (setq left-fringe-width 0)
      (setq right-fringe-width 0)

      ;; makes the icons smaller, once there's no face settings
      ;; for them.
      (text-scale-set -1)

      ;; Set width here so it takes scaled font size
      (setq neo-window-width 24)
      (setq neo-window-fixed-size nil))

    (add-hook 'neotree-mode-hook 'hmz-neotree-mode-hook)

    (defadvice neo-buffer--refresh (after hmz-keep-hl-line-after-buffer-refresh 1 () activate)
      "Keep hl-line active after refreshing neotree's tree."
      (hl-line-mode t)
      (setq hl-line-sticky-flag t))

    (defadvice tabbar-cycle (after hmz-refresh-neotree-upon-cycle-tabs 1 () activate)
      (when (neo-global--window-exists-p)
        (neotree-refresh t )))

    (defadvice next-buffer (after hmz-refresh-neotree-change-next-buffer 1 () activate)
      (when (not (eq buffer-file-name neo-buffer-name))
        (if (buffer-file-name)
            (neotree-refresh t)
          (neotree-hide)
          ))
      )

    (setq hmz-neotree-hidden t)

    (defadvice previous-buffer (after hmz-refresh-neotree-change-previous-buffer 1 () activate)
      (when (not (eq buffer-file-name neo-buffer-name))
        (if (or buffer-file-name (not hmz-neotree-hidden))
            (neotree-refresh t)
          (neotree-hide)
          ))
      )

    (defun neo-global--do-autorefresh ()
      "Overriden version of neotree refresh function that doesn't try to refresh buffers that are not visiting a file and generating error and jumping cursor as result."
      (interactive)
      (when (and neo-autorefresh (neo-global--window-exists-p) buffer-file-name (not (eq (current-buffer) "*NeoTree*"))
                 (neotree-refresh t))))
    ))
