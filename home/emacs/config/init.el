(setq-default tab-width 4)

(set-face-attribute 'default nil
    :font "Iosevka"
    :height 115
    :weight 'medium)
(set-face-attribute 'variable-pitch nil
    :font "Iosevka Aile"
    :height 115
    :weight 'medium)
(set-face-attribute 'bold nil
    :weight 'heavy)

(scroll-bar-mode -1)
(tool-bar-mode -1)


;; Packages

(eval-when-compile
        (require 'use-package))
(setq use-package-always-ensure t)

(use-package solarized-theme
  :config
  (load-theme 'solarized-dark t))

(use-package pdf-tools
  :config
  (pdf-loader-install))

(use-package yasnippet
  :custom
  (yas-snippet-dirs '("~/.config/emacs/snippets"))
  :config
  (yas-global-mode 1))

(use-package tex
  :ensure auctex
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil))

(use-package cdlatex
  :hook (org-mode . turn-on-org-cdlatex))

(use-package org
  :ensure nil
  :bind (("C-c l" . org-store-link)
		 ("C-c a" . org-agenda)
		 ("C-c c" . org-capture))
  :custom
  (org-list-demote-mode '(("+" . "-") ("-" . "*") ("*" . "+")))
  (org-hide-emphasis-markers t)
  (org-use-sub-superscripts "{}")
  (org-startup-with-inline-images t)
  (org-startup-with-latex-preview t)
  (org-image-actual-width '(300))
  :config
  (plist-put org-format-latex-options :scale 1.3))

(use-package org-appear
  :after org
  :hook (org-mode . org-appear-mode))

(use-package org-fragtog
  :after org
  :hook (org-mode . org-fragtog-mode))

(use-package org-modern
  :after org
  :config
  (global-org-modern-mode)
  (set-face-attribute 'org-modern-symbol nil
					  :font "Iosevka"
					  :height 115
					  :weight 'medium))

(use-package org-roam
  :after org)

(use-package ligature
  :config
  (ligature-set-ligatures 't '("-<<" "-<" "-<-" "<--" "<---" "<<-" "<-" "->" "->>" "-->" "--->" "->-" ">-" ">>-"
                             "=<<" "=<" "=<=" "<==" "<===" "<<=" "<=" "=>" "=>>" "==>" "===>" "=>=" ">=" ">>="
                             "<->" "<-->" "<--->" "<---->" "<=>" "<==>" "<===>" "<====>" "::" ":::" "__"
                             "<~~" "</" "</>" "/>" "~~>" "==" "!=" "<>" "===" "!==" "!==="
                             "<:" ":=" "*=" "*+" "<*" "<*>" "*>" "<|" "<|>" "|>" "<." "<.>" ".>" "+*" "=*" "=:" ":>"
                             "(*" "*)" "/*" "*/" "[|" "|]" "{|" "|}" "++" "+++" "\\/" "/\\" "|-" "-|" "<!--" "<!---"))
  (global-ligature-mode t))

(use-package nix-mode
  :mode ("\\.nix\\'" "\\.nix.in\\'"))
