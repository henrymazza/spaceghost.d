;; -*- lexical-binding:t -*-
;; -*- coding: utf-8; -*-

;;(require 'req-package)

(defvar hmz-tabbar-packages
  '(tabbar)
  "List of all packages to install and/or initialize. Built-in packages
which require an initialization must be listed explicitly in the list.")

(defun hmz-tabbar/init-tabbar ()
  "Tabbar customizations"
  (use-package tabbar
    :straight t
    :defer 1
    :bind ("s-b" . tabbar-mode)
    ;; :requires helm-lib
    ;; :ensure all-the-icons

    :config
      (defun ido-switch-tab-group ()
        "Switch tab groups using ido."
      (interactive)
        (let* ((tab-buffer-list (mapcar
                #'(lambda (b)
                    (with-current-buffer b
                      (list (current-buffer)
                            (buffer-name)
                            (funcall tabbar-buffer-groups-function) )))
                    (funcall tabbar-buffer-list-function)))
            (groups (delete-dups
              (mapcar #'(lambda (group)
                (car (car (cdr (cdr group))))) tab-buffer-list)))
            (group-name (ido-completing-read "Groups: " groups)) )
          (catch 'done
            (mapc
              #'(lambda (group)
                (when (equal group-name (car (car (cdr (cdr group)))))
                  (throw 'done (switch-to-buffer (car (cdr group))))))
              tab-buffer-list) )))

      (defun switch-tab-group (group-name)
        "Switch to a specific tab group."
        (let ((tab-buffer-list (mapcar
                #'(lambda (b)
                    (with-current-buffer b
                      (list (current-buffer)
                            (buffer-name)
                            (funcall tabbar-buffer-groups-function) )))
                    (funcall tabbar-buffer-list-function))))
          (catch 'done
            (mapc
              #'(lambda (group)
                (when (equal group-name (format "%s" (car (car (cdr (cdr group))))))
                  (throw 'done (switch-to-buffer (car (cdr group))))))
              tab-buffer-list) )))

      (defun switch-to-tab-group-n ()
      "Switch to a predefined existing tab group named `N`."
      (interactive)
        (switch-tab-group "N"))

      (defun switch-to-tab-group-a ()
      "Switch to a predefined existing tab group named `A`."
      (interactive)
        (switch-tab-group "A"))

      (global-set-key [(control ";")] 'switch-tab-group)

      (define-key evil-normal-state-map (kbd "C-;") 'ido-switch-tab-group)

    ;; END SWITCH BUFFER

    ;; safari like back and forward tabs
    (global-set-key [(control shift tab)] 'tabbar-backward-tab)
    (global-set-key [(control tab)] 'tabbar-forward-tab)

    ;; make tab and shift tab move between MRU buffers
    (define-key evil-normal-state-map (kbd "<S-tab>") 'previous-buffer)
    (define-key evil-normal-state-map (kbd "<tab>") 'next-buffer)

    ;; cycle groups
    (define-key evil-normal-state-map (kbd "s-[") 'tabbar-backward-group)
    (define-key evil-normal-state-map (kbd "s-]") 'tabbar-forward-group)
    (define-key evil-normal-state-map (kbd "{") 'tabbar-backward-group)
    (define-key evil-normal-state-map (kbd "}") 'tabbar-forward-group)

    ;; Sets command + 1 up to command + 0 as jump to group

    (seq-do (lambda (e)
              (global-set-key (kbd (concat "s-" (number-to-string e))) 'hmz-tabbar/goto-nth-group)
              )
            (number-sequence 1 9))

    (defun hmz-tabbar/goto-nth-group ()
      (interactive)
      (let* ((vect (recent-keys))
             (last-keystroke (aref vect (1- (length vect))))
             (invoked-with-keys (key-description (vector last-keystroke)))
             ;; start with zero
             (integer-argument (- (aref invoked-with-keys (1- (length invoked-with-keys))) 49))
             (new-group-tab (nth integer-argument (tabbar-tabs (tabbar-get-tabsets-tabset)))))

        (when new-group-tab
          (tabbar-click-on-tab new-group-tab))))

    ;; map mouse wheel events on header line
    (global-set-key [header-line triple-wheel-right] 'tabbar-press-scroll-right)
    (global-set-key [header-line double-wheel-right] 'tabbar-press-scroll-right)
    (global-set-key [header-line wheel-right] nil)
    (global-set-key [header-line triple-wheel-left] 'tabbar-press-scroll-left)
    (global-set-key [header-line double-wheel-left] 'tabbar-press-scroll-left)
    (global-set-key [header-line wheel-left] nil)

    (setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . 30)))
    (setq mouse-wheel-progressive-speed nil)

    :config
    (defun plist-merge (&rest plists)
      (if plists
          (let ((result (copy-sequence (car plists))))
            (while (setq plists (cdr plists))
              (let ((plist (car plists)))
                (while plist
                  (setq result (plist-put result (car plist) (car (cdr plist)))
                        plist (cdr (cdr plist))))))
            result)
        nil))


    (defun hmz-lighten-if-too-dark (icon-face)
      "Lighen color if (TODO) it's considered too dark."
      (color-lighten-name (face-attribute (plist-get icon-face :inherit) :foreground nil 'default) 2))

    ;; override so we can change default value instead of custom one
    (setq tabbar-separator (list 1.2))

    (defun hmz-tabbar-refresh-faces ()
      "Refreshes faces dependent of theme faces."

      (set-face-attribute 'tabbar-default nil
                          :inherit 'header-line
                          :foreground 'unspecified
                          :background 'unspecified
                          :underline nil
                          :weight 'light
                          :box nil)

      (set-face-attribute 'tabbar-selected-modified nil
                          :box nil
                          :foreground (face-attribute 'font-lock-keyword-face :foreground)
                          :inherit 'tabbar-selected
                          :overline nil
                          :weight 'normal)

      (set-face-attribute 'tabbar-selected nil
                          :box nil
                          :foreground 'unspecified
                          :background (face-attribute 'default :background)
                          :inherit 'tabbar-default
                          :underline (face-attribute 'font-lock-comment-face :background)
                          :overline nil
                          :weight 'normal)

      (set-face-attribute 'tabbar-highlight nil
                          :inherit 'tabbar-default
                          :foreground (face-attribute
                                       'font-lock-keyword-face :foreground)
                          :underline nil
                          :overline nil
                          :box nil)

      (set-face-attribute 'tabbar-modified nil
                          :box nil
                          :foreground (face-attribute 'font-lock-keyword-face :foreground)
                          :background 'unspecified
                          :weight 'normal
                          :inherit 'tabbar-default)

      (set-face-attribute 'tabbar-unselected nil
                          :foreground 'unspecified
                          :background 'unspecified
                          :box nil
                          :underline 'unspecified
                          :inherit 'tabbar-default)

      (set-face-attribute 'tabbar-button nil
                          :height 2.0
                          :inherit 'tabbar-default)

      (defface tabbar-icon-unselected '((t
                                         :foreground "#555555"
                                         :box nil
                                         :inherit 'tabbar-default
                                         ))
        "Unselected tab's icon foreground color."
        :group 'tabbar)

      ;; set colors through here so it can be dinamically redone
      (set-face-attribute 'tabbar-icon-unselected nil
                          :foreground (face-attribute 'font-lock-comment-face :foreground)
                          :background 'unspecified
                          :underline (face-attribute 'font-lock-variable-name-face :foreground)))

    (hmz-tabbar-refresh-faces)

    (use-package all-the-icons
      :config
      (add-to-list 'all-the-icons-icon-alist
                   '("\\.lua$" all-the-icons-wicon "moon-waning-crescent-3" :face all-the-icons-cyan)))

    (defun tabbar-buffer-help-on-tab (tab)
      "Return the help string shown when mouse is onto TAB. This function was overriden to show more useful information."
      (if tabbar--buffer-show-groups
          (let* ((tabset (tabbar-tab-tabset tab))
                 (tab (tabbar-selected-tab tabset)))
            (format "mouse-1: switch to buffer %S in group [%s]"
                    (buffer-name (tabbar-tab-value tab)) tabset))
        (propertize (format "%s"
                (file-relative-name
                 (projectile-expand-root (buffer-file-name (tabbar-tab-value tab)))
                 (projectile-project-root))) 'face '(:height 1.2 :weight light))))

    ;; Override function that writes tab names so we can insert
    ;; an stylized text with icons
    (defsubst tabbar-line-tab (tab)
      "Return the display representation of tab TAB.
That is, a propertized string used as an `header-line-format' template
element.
Call `tabbar-tab-label-function' to obtain a label for TAB."

      (let*
          ((tab-face (cond ((and (tabbar-selected-p tab (tabbar-current-tabset))
                                 (tabbar-modified-p tab (tabbar-current-tabset)))
                            'tabbar-selected-modified)
                           ((tabbar-selected-p tab (tabbar-current-tabset))
                            'tabbar-selected)
                           ((tabbar-modified-p tab (tabbar-current-tabset))
                            'tabbar-modified)
                           (t 'tabbar-unselected)))

           (the-icon (all-the-icons-icon-for-file
                      (replace-regexp-in-string "<.*>" "" (format "%s"(tabbar-tab-value tab)))))

           (tab-is-active (tabbar-selected-p tab (tabbar-current-tabset)))

           (icon-face (plist-get (text-properties-at 0 the-icon) 'face)))

        (concat
         (propertize
                     " "
           (if tabbar-tab-label-function
               (funcall tabbar-tab-label-function tab)
             tab) " "
          'tabbar-tab tab
          'local-map (tabbar-make-tab-keymap tab)
          'help-echo 'tabbar-help-on-tab
          'mouse-face 'tabbar-highlight
          'face tab-face
          'display `(raise  0.0);;,(symbol-value 'hmz-tabbar-raise-text))
          'pointer 'hand)
         (propertize
          the-icon
          'face (plist-merge
                 ;; (get icon-face 'foreground)
                 (plist-get (text-properties-at 0 the-icon) 'face)
                 `(:background ,(face-attribute 'tabbar-default :background nil 'default))
                 (if tab-is-active
                     `(:overline nil;; ,(face-attribute tab-face :foreground nil 'default)
                                 :foreground ,(hmz-lighten-if-too-dark icon-face)
                                 :background ,(face-attribute 'tabbar-selected :background nil 'default))
                   `(:foreground ,(face-attribute 'tabbar-icon-unselected :foreground nil 'default)))
                 )
          'display (if tab-is-active '(raise 0.0) '(raise 0.0))
          'tabbar-tab tab
          'local-map (tabbar-make-tab-keymap tab)
          'help-echo 'tabbar-help-on-tab
          'mouse-face 'tabbar-highlight)

         (propertize
          (concat
           " "
           (if tabbar-tab-label-function
               (funcall tabbar-tab-label-function tab) tab) " ")
          'tabbar-tab tab
          'local-map (tabbar-make-tab-keymap tab)
          'help-echo 'tabbar-help-on-tab
          'mouse-face 'tabbar-highlight
          'face tab-face
          'display `(raise 0.2) ;;,(symbol-value 'hmz-tabbar-raise-text))
          'pointer 'hand)
         tabbar-separator-value)))

    (defsubst tabbar-line-button (name)
      "Return the display representation of button NAME.
That is, a propertized string used as an `header-line-format' template
element."
      (position
       (tabbar-current-tabset)
       (mapcar #'cdr
               (tabbar-tabs (tabbar-get-tabsets-tabset))))

      (let* ((label (if tabbar-button-label-function
                        (funcall tabbar-button-label-function name)
                      (cons name name)))

             (glyph
              (cond ((eq name 'home)
                     (concat " "
                             (all-the-icons-wicon
                              (nth

                               ;; Use current group to define icon
                               (or (position
                                    (tabbar-current-tabset)
                                    (mapcar #'cdr
                                            (tabbar-tabs (tabbar-get-tabsets-tabset)))
                                    ) 7)

                               ;; Use current window number to define the icon
                               ;; (if winum-mode (winum-get-number) 1)

                                   '("alien" "fire" "lightning" "barometer" "meteor" "earthquake" "snowflake-cold" "fire" "raindrop" "solar-eclipse" "night-clear" "raindrops" "sprinkle"))
                              :face '(:inherit tabbar-default :height 1.2))))

                          ((eq name 'scroll-left) (all-the-icons-material "chevron_left"))
                          ((eq name 'scroll-right) (all-the-icons-material "chevron_right"))
                          (t "X")))

             (raise-amount 0.0)

             (tabset-name (if (eq name 'scroll-left)
                              (propertize (format "%s" (tabbar-current-tabset))
                                          'face '(:inherit tabbar-default
                                                           :height 1.3)
                                          'display '(raise 0.1)) "")))

        (tabbar-set-template tabset nil)
        ;; Cache the display value of the enabled/disabled buttons in
        ;; variables `tabbar-NAME-button-value'.
        (set (intern (format "tabbar-%s-button-value" name))
             (cons
              (concat
               (propertize glyph
                           'tabbar-button name
                           'face (plist-merge
                                  '(:inherit tabbar-default)
                                  (plist-get (text-properties-at (- (length glyph) 1) glyph) 'face)
                                  `(:foreground ,(face-attribute 'font-lock-keyword-face :foreground nil))
                                  )
                           'display '(raise raise-amount)
                           ;; (list 'space :width (car tabbar-separator))
                           'mouse-face 'tabbar-button-highlight
                           'pointer 'hand
                           'local-map (tabbar-make-button-keymap name)
                           'help-echo 'tabbar-help-on-button)
               (unless (string-equal tabset-name "tabbar-tabsets-tabset") tabset-name))

              (concat
               (propertize glyph
                           'tabbar-button name
                           'face (plist-merge
                                  '(:inherit tabbar-default)
                                  (plist-get (text-properties-at 0 glyph) 'face))
                           'display '(raise raise-amount)
                           'mouse-face 'tabbar-button-highlight
                           'pointer 'hand
                           'local-map (tabbar-make-button-keymap name)
                           'help-echo 'tabbar-help-on-button)
               (unless (string-equal tabset-name "tabbar-tabsets-tabset") tabset-name)
               )))))

    (defadvice tabbar-line-format (after tabbar-button-cache-clearer 1 (tabset) activate)
      "Clear cached button values each time `tabbar-line-format' is called
       so tabbset name gets refreshed."
      (setq tabbar-scroll-left-button-value nil)
      (setq tabbar-scroll-right-button-value nil)
      (setq tabbar-home-button-value nil))

    (defun tabbar-buffer-tab-label (tab)
      "Return a label for TAB. That is, a string used to represent it on the
       tab bar. This was overriden to clean up unwanted chars."

      (let ((label (if tabbar--buffer-show-groups
                       (replace-regexp-in-string
                        "*" "" (format "%s" (tabbar-tab-tabset tab)))
                     (format "%s" (tabbar-tab-value tab)))))
        ;; Unless the tab bar auto scrolls to keep the selected tab
        ;; visible, shorten the tab label to keep as many tabs as possible
        ;; in the visible area of the tab bar.
        (if tabbar-auto-scroll-flag
            label
          (tabbar-shorten
           label (max 1 (/ (window-width)
                           (length (tabbar-view
                                    (tabbar-current-tabset)))))))))

    (defun tabbar-buffer-update-groups ()
      "Update tab sets from groups of existing buffers.
  Return the the first group where the current buffer is."
      ;; (message ">> %s" tabbar--buffers)
      (let ((bl (sort
                 (mapcar
                  ;; for each buffer, create list: buffer, buffer name, groups-list
                  ;; sort on buffer name; store to bl (buffer list)
                  #'(lambda (b)
                      (with-current-buffer b
                        (list (current-buffer)
                                (format "%10s" (nth 0 (nth 5 (file-attributes (buffer-file-name )))))
                              ;; (format "%10d" (buffer-chars-modified-tick))
                              (if tabbar-buffer-groups-function
                                  (funcall tabbar-buffer-groups-function)
                                '("Common")))))
                  (and tabbar-buffer-list-function
                       (funcall tabbar-buffer-list-function)))
                 #'(lambda (e1 e2)
                     (string-lessp (nth 1 e1) (nth 1 e2))))))
        ;; If the cache has changed, update the tab sets.
        (unless (equal bl tabbar--buffers)
          (message "it differs")
          ;; Add new buffers, or update changed ones.
          (dolist (e bl) ;; loop through buffer list
            (dolist (g (nth 2 e)) ;; for each member of groups-list for current buffer
              (let ((tabset (tabbar-get-tabset g))) ;; get group from group name
                (if tabset ;; if group exists
                    ;; check if current buffer is same as any cached buffer
                    ;; (search buffer list for matching buffer)
                    (unless (equal e (assq (car e) tabbar--buffers)) ;; if not,...
                      ;; This is a new buffer, or a previously existing
                      ;; buffer that has been renamed, or moved to another
                      ;; group.  Update the tab set, and the display.
                      (tabbar-add-tab tabset (car e) t) ;; add to end of tabset
                      (tabbar-set-template tabset nil))
                  ;;if tabset doesn't exist, make a new tabset with this buffer
                  (tabbar-make-tabset g (car e))))))
          ;; Remove tabs for buffers not found in cache or moved to other
          ;; groups, and remove empty tabsets.
          (mapc 'tabbar-delete-tabset ;; delete each tabset named in following list:
                (tabbar-map-tabsets ;; apply following function to each tabset:
                 #'(lambda (tabset)
                     (dolist (tab (tabbar-tabs tabset)) ;; for each tab in tabset
                       (let ((e (assq (tabbar-tab-value tab) bl))) ;; get buffer
                         (or (and e (memq tabset ;; skip if buffer exists and tabset is a member of groups-list for this buffer
                                          (mapcar 'tabbar-get-tabset
                                                  (nth 2 e))))
                             (tabbar-delete-tab tab)))) ;; else remove tab from this set
                     ;; Return empty tab sets
                     (unless (tabbar-tabs tabset)
                       tabset)))) ;; return list of tabsets, replacing non-empties with nil
          ;; NOTE: it looks like tabbar--buffers is getting nil'ed somewhre,
          ;; using an alternative cache.
          ;; The new cache becomes the current one.
           (setq tabbar--buffers bl)

          ))
      ;; Return the first group the current buffer belongs to.
      (car (nth 2 (assq (current-buffer) tabbar--buffers))))

    ;; Tabbar Groups Definition
    (defun tabbar-buffer-groups ()
      "Returns the name of the tab group names the current buffer belongs to.
      There are two groups: Emacs buffers (those whose name starts with '*', plus
      dired buffers), and the rest."
      (list (if (member (buffer-name)
                        (helm-skip-entries
                         (mapcar #'buffer-name (buffer-list))
                         (append '("\\`[:\\*]\\(Back\\|Help\\)")
                                 helm-boring-buffer-regexp-list)
                         helm-white-buffer-regexp-list))
                (cond
                 ((file-remote-p default-directory)
                  (string-join
                   `( ,(file-remote-p default-directory 'user)
                      ,(file-remote-p default-directory 'host))
                   "@")
                  )

                 ((string-match-p "*" (buffer-name))
                  (if (or (get-buffer-process (current-buffer))
                          (eq major-mode 'eshell-mode))
                      "proc"
                    "limbo"))
                 ((eq major-mode 'dired-mode) "dired")
                 ((string-match-p "magit" (symbol-name major-mode))
                  "magit")
                 ((projectile-project-p) (projectile-project-name))
                 ((buffer-file-name) "other")
                 (t "limbo"))
              "limbo")))

    (defun hmz-tabbar-refresh-tabs ()
      (if tabbar-mode
          (progn(tabbar-mode 0)
                (setq tabbar-scroll-left-button-value nil)
                (setq tabbar-scroll-right-button-value nil)
                (setq tabbar-home-button-value nil)

                (hmz-tabbar-refresh-faces)

                (tabbar-mode 1))))

    (unless (boundp 'after-load-theme-hook)
      (defvar after-load-theme-hook nil
        "Hook run after a color theme is loaded using `load-theme'.")
      (defadvice load-theme (after run-after-load-theme-hook activate)
       "Run `after-load-theme-hook'."
        (run-hooks 'after-load-theme-hook)))

    ;; NOTE: more of the patch: stop turning on and off so often
    (add-hook 'after-load-theme-hook 'hmz-tabbar-refresh-tabs)
    (add-hook 'after-save-hook 'hmz-tabbar-refresh-tabs)
    (add-hook 'first-change-hook 'hmz-tabbar-refresh-tabs)

    ;; init me!
  (tabbar-mode 1)
  ;; redefine tabbar-add-tab so that it alphabetizes / sorts the tabs
  ;; TODO: better treat non-file buffers in sort
  (defun tabbar-add-tab (tabset object &optional append)
    "Add to TABSET a tab with value OBJECT if there isn't one there yet.
  If the tab is added, it is added at the beginning of the tab list,
  unless the optional argument APPEND is non-nil, in which case it is
  added at the end."
    (let ((tabs (tabbar-tabs tabset)))
      (if (tabbar-get-tab object tabset)
          tabs
        (let* (
            (tab (tabbar-make-tab object tabset))
            (tentative-new-tabset
              (if append
                (append tabs (list tab))
                (cons tab tabs)))
            (new-tabset
              (sort
                tentative-new-tabset
                #'(lambda (e1 e2)
                    (setq file1 (buffer-local-value 'buffer-file-name (get-buffer (car e1)))
                          file2 (buffer-local-value 'buffer-file-name (get-buffer (car e2))))
                    (if (and file1 file2)
                      (not (time-less-p
                            (file-attribute-modification-time
                             (file-attributes (expand-file-name file1)))
                            (file-attribute-modification-time

                             (file-attributes (expand-file-name file2)))
                            ))
                      t)

                    ))))
          (tabbar-set-template tabset nil)
          (set tabset new-tabset))))))
