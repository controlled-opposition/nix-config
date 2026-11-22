(setf (alist-get 'font default-frame-alist) "Paper Mono")

(use-package evil
  :ensure t
  :demand t
  :config
  (evil-mode 1))

(use-package agent-shell
  :ensure t
  :commands agent-shell)
