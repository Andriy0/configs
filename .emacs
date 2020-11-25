(require 'package)

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)

(defun compile_run ()
  "Compile the program and run in alacritty."
  (interactive)
  (save-buffer)
  (shell-command "alacritty --title float -e bash -c \"make run\""))

(add-hook 'c-mode-common-hook
	  (lambda () (define-key c-mode-base-map (kbd "C-c C-m") 'compile_run)))
(add-hook 'c-mode-common-hook 'development-mode)
; (add-hook 'emacs-lisp-mode-hook 'development-mode)

(defun development-mode ()
  "Mode used for development"
  (interactive)
  (company-mode t)
  (company-box-mode t)
  (hs-minor-mode t)
  ; (highlight-numbers-mode t)
  (lsp t))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tango-dark))
 '(package-selected-packages
   '(lsp-ivy company-box projectile lsp-mode company-irony flycheck-irony irony-eldoc irony)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "mononoki Nerd Font Mono" :foundry "UKWN" :slant normal :weight bold :height 143 :width normal)))))

 
