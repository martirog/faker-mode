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

    (define-key map (kbd "w") 'ispell-word)
    (define-key map (kbd "d") 'diff-buffer-with-file)
    (define-key map (kbd "q") 'quit-window)
    (define-key map (kbd "a") 'mark-word)
    (define-key map (kbd "r") 'string-rectangle)

    (define-key map (kbd "z") 'vc-print-log)
    (define-key map (kbd "x") 'vc-print-root-log)
    (define-key map (kbd "c") 'vc-annotate)
    (define-key map (kbd "v") 'vc-dir)
    (define-key map (kbd "b") 'vc-ediff)

    (define-key map (kbd "ø") 'facker-disable-map)
    map)
  "key map in active facker mode")

(defvar-local faker-prewview-state nil)
(defvar faker-prewview-window nil)

(defun facker-disable-map ()
    (interactive)
    (facker-mode -1))

(defun faker-insert-erase-prewview ()
  "remove faker fild texst"
  (with-selected-window faker-prewview-window ;use the correct window here
    (if (equal (get-text-property (- (point) 1) 'field) 'faker-prewview)
        (delete-field))
    (insert (nth 2 faker-prewview-state))))

(defun faker-insert-prewview ()
  (let* ((pre-view (propertize (minibuffer-contents) 'field 'faker-prewview))
         (pre-view-length (length pre-view)))
    (message pre-view)
    (with-selected-window faker-prewview-window ;use the correct window here
      (if (eq (get-text-property (- (point) 1) 'field) 'faker-prewview)
          (delete-field))
      (unless (equal pre-view-length 0)
        (message pre-view)
        (insert pre-view)))))  ; insert preview

(defun facker-insert-text (text)
  "insert single line text while still in faker mode"
  (interactive
   (progn
     (make-local-variable 'faker-prewview-state)
     (let (start end)
       (if (use-region-p)
           (setq start (region-beginning)
                 end (region-beginning)
                 start-string (delete-and-extract-region (region-beginning) (region-end)))
         (setq start (point)
               end (point)
               start-string nil))
       (setq faker-prewview-state `(,start ,end ,start-string))
       (setq faker-prewview-window (selected-window))
       (list
        (minibuffer-with-setup-hook
           (lambda ()
             (add-hook 'minibuffer-exit-hook #'faker-insert-erase-prewview nil t)
             (add-hook 'post-command-hook #'faker-insert-prewview nil t))
          (read-string "faker-insert: ")))))) ; need to add histrory here

  (if (use-region-p)
      (delete-and-extract-region (region-beginning) (region-end)))
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
