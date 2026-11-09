;; -*- lexical-binding: t; -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(defun reload-init-file ()
  (interactive)
  (load-file user-init-file))

(global-set-key (kbd "C-c r") #'reload-init-file)

;; Save all backup and auto-save files to one folder
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))
(setq auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))


(select-frame-set-input-focus (selected-frame))
(setq inhibit-startup-screen t)
(load-theme 'modus-vivendi t)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(font . "Paper Mono-12"))
(when (display-graphic-p)
  (set-face-attribute 'default nil :font "Paper Mono-12"))
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

(use-package ghostel
  :ensure t)

(use-package treemacs
  :ensure t
  :bind ("C-c t" . treemacs))

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

(use-package emureader
  :ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(ein envrc ghostel)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package ein
  :ensure t
  :commands (ein:notebooklist-open ein:run ein:login)
  :init
  ;; If you are using JupyterLab 3.0+, change the subcommand from "notebook" to "server"
  ;; (setq ein:jupyter-server-use-subcommand "server")
  
  :config
  ;; Enable inline images inside Emacs buffers (defaults to an external viewer)
  (setq ein:output-area-inlined-images t)
  
  ;; Custom keybindings or hook setups can go here
  )

(use-package envrc
  :ensure t
  :config
  (envrc-global-mode 1))
