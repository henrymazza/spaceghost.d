(defvar hmz-color-identifiers-packages
  '(
    rainbow-mode
    rainbow-identifiers
    rainbow-delimiters
    )
)

(defun hmz-color-identifiers/init-rainbow-mode ()
  "Initialize Rainbow Mode to show color values as string backgrounds."

  (use-package rainbow-mode)

  (add-hook 'prog-mode-hook
            (lambda ()
              (setq rainbow-mode 1)
              ))
  )


(defun hmz-color-identifiers/init-rainbow-identifiers ()
  "Initialization of rainbow indentifiers in hmz-color-identifiers layer."

  (use-package rainbow-identifiers
    :ensure t
    :config
    (defun make-local-face (face-name &rest args)
      "Make a buffer face local"
      (interactive)
      (let ((local-face (intern (concat (symbol-name face-name) "-local"))))
        ;; First create new face which is a copy of the old face
        (copy-face face-name local-face)
        (apply 'set-face-attribute local-face nil args)
        (set (make-local-variable face-name) local-face)))

    (defun default-foreground-lightness ()
      (+ 10 (* 85 (third
                   (apply #'color-rgb-to-hsl
                          (color-name-to-rgb
                           (face-attribute 'default :foreground nil))
                          )))))

    (defun hmz-color-identifiers/regenerate-rainbow-colors ()
      (use-package color)
      (setq ns-use-srgb-colorspace t)
      (message "Lightness is: %s" (default-foreground-lightness))
      (loop for i from 1 to 15 do
            (let* (
                   (lightness (default-foreground-lightness))
                   (saturation 70)
                   (angle (* 2 pi (/ i 15.0)))
                   (a (* saturation (cos angle)))
                   (b (* saturation (sin angle)))
                   (rgb-color (color-lab-to-srgb lightness a b))
                   (max-component (apply #'max rgb-color))
                   )

              (when (> max-component 1.0)
                ;; Keep components inside RGB gamut.
                ;; (message "Warning: rainbow-identifiers-identifier-%s saturated gamut." i)
                (setq rgb-color
                      (mapcar #'(lambda (c)
                                  (/ c max-component)) rgb-color)))

              (message "> %s" (apply 'color-rgb-to-hex rgb-color))

              (set-face-attribute
               (intern (format "rainbow-identifiers-identifier-%s" i))
               nil
               :foreground (apply 'color-rgb-to-hex rgb-color))))
      ))

    (add-hook 'prog-mode-hook
              (lambda ()
                (rainbow-identifiers-mode t)
                (rainbow-delimiters-mode-enable)
                ))

    (defvar after-load-theme-hook nil
      "Hook run after a color theme is loaded using `load-theme'.")
    (defadvice load-theme (after run-after-load-theme-hook activate)
      "Run `after-load-theme-hook'."
      (run-hooks 'after-load-theme-hook))

    (add-hook 'after-load-theme-hook 'hmz-color-identifiers/regenerate-rainbow-colors)

    )
