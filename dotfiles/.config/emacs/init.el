;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; This file is a mutable dotfile.

;;; Code:

(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message t)

(electric-pair-mode 1)
(setq electric-pair-pairs
      '(
        (?\" . ?\")
        (?\{ . ?\})
        (?\< . ?\>)
        (?$  . ?$)
        (?\' . ?\')
        ))

(show-paren-mode 1)
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(global-visual-line-mode 1)
(which-key-mode)
(pixel-scroll-mode)

(setq kill-buffer-query-functions
      (remq 'process-kill-buffer-query-function
            kill-buffer-query-functions))

(setq use-short-answers t)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode))

(use-package eglot
  :ensure nil
  :commands (eglot eglot-ensure)
  :config
  (setf (alist-get 'nix-mode eglot-server-programs) '("nixd")))

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'"
  :hook (nix-mode . eglot-ensure))

(select-frame-set-input-focus (selected-frame))

(use-package tex
  :ensure auctex)

(use-package cdlatex
  :ensure t
  :hook ((LaTeX-mode . turn-on-cdlatex)
         (org-mode   . turn-on-org-cdlatex)))

;; Enable LaTeX previews in Org
(use-package org
  :config
  (setq org-startup-with-latex-preview t))

;; Optional: auto-toggle previews when moving cursor
(use-package org-fragtog
  :ensure t
  :hook (org-mode . org-fragtog-mode))

;; Magit needs a newer Transient than the one bundled with this Emacs build.
(use-package transient
  :ensure t)

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode 1))

(use-package org-modern
  :ensure t
  :config
  (global-org-modern-mode 1))

(set-face-attribute 'default nil :family "JetBrains Mono" :height 130 :weight 'regular)
(set-face-attribute 'fixed-pitch nil :family "JetBrains Mono" :height 1.0)

(use-package elcord
  :ensure t
  :config
  (elcord-mode 1))

(use-package ghostel
  :ensure t)

(use-package nerd-icons
  :ensure t
  :custom
  (nerd-icons-font-family "JetBrains Mono Nerd Font"))

(use-package ef-themes
  :ensure t
  :init
  (ef-themes-take-over-modus-themes-mode 1)
  :bind
  (("<f5>" . modus-themes-rotate)
   ("C-<f5>" . modus-themes-select)
   ("M-<f5>" . modus-themes-load-random))
  :config
  (modus-themes-load-theme 'ef-cherie))

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

;;; init.el ends here
