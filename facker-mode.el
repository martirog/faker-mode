(defvar facker-map  (let ((map (make-sparse-keymap)))
    (suppress-keymap map t)
    (define-key map (kbd "i") 'previous-line)
    (define-key map (kbd "k") 'next-line)
    (define-key map (kbd "j") 'left-char)
    (define-key map (kbd "l") 'right-char)

    (define-key map (kbd "I") 'backward-paragraph)
    (define-key map (kbd "K") 'forward-paragraph)
    (define-key map (kbd "J") 'left-word)
    (define-key map (kbd "L") 'right-word)

    (define-key map (kbd "<SPC> i") 'windmove-up)
    (define-key map (kbd "<SPC> k") 'windmove-down)
    (define-key map (kbd "<SPC> j") 'windmove-left)
    (define-key map (kbd "<SPC> l") 'windmove-right)

    (define-key map (kbd "h") 'facker-insert-text)

    (define-key map (kbd "w") 'diff-buffer-with-file)
    (define-key map (kbd "d") 'kill-line)
    (define-key map (kbd "q") 'quit-window)
    (define-key map (kbd "a") 'mark-word)
    (define-key map (kbd "r") 'string-rectangle)

    (define-key map (kbd "z") 'vc-print-log)
    (define-key map (kbd "x") 'vc-print-root-log)
    (define-key map (kbd "c") 'vc-annotate)
    (define-key map (kbd "v") 'vc-dir)
    (define-key map (kbd "b") 'vc-ediff)

    (define-key map (kbd "<return>") 'facker-disable-map)
    map)
  "key map in active facker mode")

(defvar facker-activate nil "controlling the facker mode map")

(defun facker-disable-map ()
    (interactive)
    (facker-mode -1))

(defun facker-insert-text (text)
  (interactive "s")
  (insert text))

(define-minor-mode facker-local-mode
  "set up verilog minor mode"
  :lighter " f"

  ;; add the facker map to the
  (add-to-list 'emulation-mode-map-alists `((facker-local-mode . ,facker-map))))

(define-globalized-minor-mode facker-mode
  facker-local-mode
  (lambda () (facker-local-mode t)))

;; Turn off the minor mode in the minibuffer
(defun facker-turn-off-local-mode ()
  "Turn off my-mode."
  (facker-local-mode -1))

(add-hook 'minibuffer-setup-hook #'facker-turn-off-local-mode)

;(provide 'facker-local-mode)
(provide 'facker-mode)
