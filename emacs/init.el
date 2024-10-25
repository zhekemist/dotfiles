(setq-default tab-width 4)

(load-theme 'solarized-dark t)

(tool-bar-mode -1)
(scroll-bar-mode -1)

(require 'org)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(setq-default org-list-demote-modify-bullet '(("+" . "-") ("-" . "*") ("*" . "+")))
(add-hook 'org-mode-hook #'turn-on-org-cdlatex)
(add-hook 'org-mode-hook 'org-fragtog-mode)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.3))

(pdf-tools-install)

(setq yas-snippet-dirs '("~/.config/emacs/snippets"))
(yas-global-mode 1)