;; -*- lexical-binding: t; -*-

(select-frame-set-input-focus (selected-frame))
(setq inhibit-startup-screen t)
(load-theme 'modus-vivendi t)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

