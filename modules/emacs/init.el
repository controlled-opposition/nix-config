;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; This file is symlinked by Home Manager.


;; Install Elpaca
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode))
(elpaca-wait)

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
  :ensure (:wait t))

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

(use-package nerd-icons-mode-line
  :ensure t
  :vc (:url "https://github.com/grolongo/nerd-icons-mode-line")
  :custom
  (nerd-icons-mode-line-v-adjust 0.1) ; default value
  (nerd-icons-mode-line-size 1.0) ; default value
  :config (nerd-icons-mode-line-global-mode t))

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
  (modus-themes-load-theme 'ef-night))

;;; init.el ends here
