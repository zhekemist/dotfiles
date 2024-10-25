(setq-default tab-width 4)

(load-theme 'solarized-dark t)

(set-face-attribute 'default nil :family "Fira Code" :height 102)
(set-face-attribute 'variable-pitch nil :family "Fira Sans" :height 102)

(scroll-bar-mode -1)
(tool-bar-mode -1)

(pdf-tools-install)

(setq yas-snippet-dirs '("~/.config/emacs/snippets"))
(yas-global-mode 1)

;; Org Mode
(require 'org)
(require 'org-modern)

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(setq-default org-list-demote-modify-bullet '(("+" . "-") ("-" . "*") ("*" . "+")))
(setq-default org-format-latex-options (plist-put org-format-latex-options :scale 1.3))

(add-hook 'org-mode-hook 'org-appear-mode)
(add-hook 'org-mode-hook #'turn-on-org-cdlatex)
(add-hook 'org-mode-hook 'org-fragtog-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

(setq-default
    org-pretty-entities t
    org-hide-emphasis-markers t
    org-use-sub-superscripts "{}"
    org-startup-with-inline-images t
    org-startup-with-latex-preview t
    org-image-actual-width '(300))

(with-eval-after-load 'org (global-org-modern-mode))
(set-face-attribute 'org-modern-symbol nil :family "Fira Code" :height 102)