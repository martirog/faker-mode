(defvar facker-map  (let ((map (make-sparse-keymap)))
    (suppress-keymap map t)
    (define-key map (kbd "i") 'previous-line)
    (define-key map (kbd "k") 'next-line)
    (define-key map (kbd "j") 'left-char)
    (define-key map (kbd "l") 'right-char)

    (define-key map (kbd "C-i") 'backward-paragraph)
    (define-key map (kbd "C-k") 'forward-paragraph)
    (define-key map (kbd "C-j") 'right-word)
    (define-key map (kbd "C-l") 'left-word)

    (define-key map (kbd "<SPC>") 'facker-disable-map)
    map)
  "key map in active facker mode")

(defvar facker-activate nil "controlling the facker mode map")

(defun facker-disable-map ()
    (interactive)
    (facker-mode -1))

(define-minor-mode facker-local-mode
  "set up verilog minor mode"
  :lighter " f"

(define-globalized-minor-mode facker-mode
  facker-local-mode
  (lambda () (facker-local-mode t)))

(provide 'facker-local-mode)
(provide 'facker-mode)

;; add the facker map to the
(add-to-list 'emulation-mode-map-alists `((facker-local-mode . ,facker-map))))

;; Turn off the minor mode in the minibuffer
(defun facker-turn-off-local-mode ()
  "Turn off my-mode."
  (facker-local-mode -1))

(add-hook 'minibuffer-setup-hook #'facker-turn-off-local-mode)
