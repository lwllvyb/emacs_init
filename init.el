;;; package --- summary
;;; Commentary:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanator
;;; Code:
(defun async-rsync()
  "Async command."
  (interactive)
  (async-start
   ;; 在子进程中要执行的lambda函数
   (lambda ()
	 (shell-command-to-string "sh /Users/liwenlong03/work/bin/rsync.sh"))

   ;;当子进程执行完成后要执行的回调，子进程执行的结果将作为回调函数的参数
   (lambda (result)
	 (message "Async rsync process done"))))

;; reload emacs configuration
(defun reload-init-file ()
  "Reload init file."
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(global-set-key (kbd "C-c r") 'reload-init-file)

;; ---------- basic -----------
;; 全屏
(toggle-frame-fullscreen)
;; 行号
(display-line-numbers-mode)
(setq inhibit-startup-message t)

;; 关闭 bell 声音; 状态栏显示
(setq visible-bell nil
      ring-bell-function 'flash-mode-line)
(defun flash-mode-line ()
  "Flash mode line."
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))

;; tool bar close
(tool-bar-mode -1)
;; yes-no to y-n
(defalias 'yes-or-no-p 'y-or-n-p)
;; close backup file.txt~
(setq make-backup-files nil)

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))
(global-hl-line-mode 1)
(set-face-background 'hl-line "#FFF000")
(save-place-mode 1)

;; ---------- end -----------


;; --------- auto down ------
;; rsync -avz rsync://mirrors.tuna.tsinghua.edu.cn/elpa/ ~/work/emacs_plugins
;; 
(when (>= emacs-major-version 24)
	(require 'package)
	(package-initialize)
	(setq package-archives
		'(("melpa-cn" . "/Users/liwenlong03/work/emacs_plugins/melpa/")
			("org-cn"   . "/Users/liwenlong03/work/emacs_plugins/org/")
			("gnu-cn"   . "/Users/liwenlong03/work/emacs_plugins/gnu/")
			("marmalade-cn"   . "/Users/liwenlong03/work/emacs_plugins/marmalade/"))))
;; 注意 elpa.emacs-china.org 是 Emacs China 中文社区在国内搭建的一个 ELPA 镜像

 ;; cl - Common Lisp Extension
(eval-when-compile (require 'cl))

 ;; Add Packages
 (defvar my/packages '(
		keyfreq
		which-key
		evil
		evil-escape
		general
		autopair
		magit
		fzf
		flycheck

		;; --- Auto-completion ---
		company
		company-go
		;; --- Better Editor ---
		helm-gtags
		swiper
		counsel
		;; --- Major Mode ---
		;; --- Minor Mode ---
		exec-path-from-shell
;; --- Themes ---
		monokai-theme
		;; solarized-theme
		) "Default packages")

 (setq package-selected-packages my/packages)

 (defun my/packages-installed-p ()
     (loop for pkg in my/packages
	   when (not (package-installed-p pkg)) do (return nil)
	   finally (return t)))

 (unless (my/packages-installed-p)
     (message "%s" "Refreshing package database...")
     (package-refresh-contents)
     (dolist (pkg my/packages)
       (when (not (package-installed-p pkg))
	 (package-install pkg))))

 ;; Find Executable Path on OS X
 (when (memq window-system '(mac ns))
   (exec-path-from-shell-initialize))

;; ---------- end -----------

(require 'package)
(setq package-enable-at-startup nil)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; 统计 按键
(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)
;; keyfreq-show 显示

(setq multi-term-program "/bin/zsh")

(use-package spacemacs-common
  :ensure spacemacs-theme
  :config (load-theme 'spacemacs-dark t))

										; 回车换行，自动添加 4 个字符
										;(setq c-basic-offset 4)
(setq-default c-basic-offset 4
              tab-width 4
              indent-tabs-mode t)
										;(setq-default indent-tabs-mode t)
										;(setq-default tab-width 4)

(use-package try
  :ensure t)

(use-package which-key
  :ensure t
  :config (which-key-mode))

										; add this to init.el
(use-package ace-window
  :ensure t
  :init
  (progn
	(global-set-key [remap other-window] 'ace-window)
	(custom-set-faces
	 '(aw-leading-char-face
	   ((t (:inherit ace-jump-face-foreground :height 3.0)))))
	))
(winner-mode 1)
;; it looks like counsel is a requirement for swiper
(use-package counsel
  :ensure t
  )

(use-package swiper
  :ensure try
  :config
  (progn
	(ivy-mode 1)
	(setq ivy-use-virtual-buffers t)
	(global-set-key "\C-s" 'swiper)
	(global-set-key (kbd "C-c C-r") 'ivy-resume)
	(global-set-key (kbd "<f6>") 'ivy-resume)

	(global-set-key (kbd "M-x") 'counsel-M-x)
	(global-set-key (kbd "C-x C-f") 'counsel-find-file)
	(global-set-key (kbd "<f1> f") 'counsel-describe-function)
	(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
	(global-set-key (kbd "<f1> l") 'counsel-load-library)
	(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
	(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
	(global-set-key (kbd "C-c g") 'counsel-git)
	(global-set-key (kbd "C-c j") 'counsel-git-grep)
	(global-set-key (kbd "C-c k") 'counsel-ag)
	(global-set-key (kbd "C-x l") 'counsel-locate)
	(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
	(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
	))

;; company
(add-hook 'after-init-hook 'global-company-mode)
(company-mode)
(global-company-mode t)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'c++-mode-hook 'global-company-mode)
(setq company-backends (delete 'company-semantic company-backends))
(setq company-backends '((company-clang
						  company-c-headers
						  company-files
						  company-keywords
						  company-dabbrev-code
						  company-gtags
						  company-etags
						  company-dabbrev
						  company-elisp
						  company-yasnippet
						  company-go)))

(setq company-dabbrev-downcase nil)

(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

;; company-go
(require 'company)                                   ; load company mode
(require 'company-go)                                ; load company mode go backend
(setq company-minimum-prefix-length 2)
(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-idle-delay .2)                         ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)                          ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing

;; go-mode hook
(setq gofmt-command "goimports")
(add-hook 'go-mode-hook (lambda()
						  (setenv "GOPATH" (concat ""
							"/Users/liwenlong03/work/mebs"
							"/Users/liwenlong03/work/mebs/src/metal/vendor"
							))
						  (add-hook 'before-save-hook 'gofmt-before-save)
						  (local-set-key (kbd "C-d") 'godef-jump)))
;; (add-hook 'go-mode-hook (lambda ()
                          ;; (set (make-local-variable 'company-backends) '(company-go))
                          ;; (company-mode)))

;; flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; vi mode
(evil-mode 1)

;(local-require 'general)
(general-evil-setup t)

;; {{ https://github.com/syl20bnr/evil-escape
(setq-default evil-escape-delay 0.3)
(setq evil-escape-excluded-major-modes '(dired-mode))
(setq-default evil-escape-key-sequence "kj")
;; disable evil-escape when input method is on
(evil-escape-mode 1)
;; }}

;;
(defun term-send-rsync()
  "Move backward word in term mode."
  (interactive)
  (term-send-raw-string "sh /vagrant/bin/rsync.sh"))

;; {{ use `,` as leader key
(general-create-definer my-comma-leader-def
  :prefix ","
  :states '(normal visual))

(my-comma-leader-def
  "gg" 'counsel-etags-grep
  "gr" 'helm-gtags-find-rtag
  "gd" 'helm-gtags-find-tag
  "gu" 'helm-gtags-update-tags
  "aa" 'copy-to-x-clipboard ; used frequently
  "ip" 'fzf-git-files
  "ii" 'counsel-imenu
  "rr" 'counsel-recentf
  "dj" 'dired-jump ;; open the dired from current file
  "kb" 'kill-buffer-and-window ;; "k" is preserved to replace "C-g"
  "xk" 'kill-this-buffer
  "xm" 'counsel-M-x
  "xz" 'multi-term-dedicated-toggle
  "xr" ' term-send-rsync
  "1"  'other-window
  "tt" 'async-rsync
  )


(setq
	helm-gtags-ignore-case t
	helm-gtags-auto-update t
	helm-gtags-use-input-at-cursor t
	helm-gtags-pulse-at-cursor t
	helm-gtags-prefix-key "\C-cg"
	helm-gtags-suggested-key-mapping t)

(require 'helm-gtags)
	;; Enable helm-gtags-mode
	(add-hook 'dired-mode-hook 'helm-gtags-mode)
	(add-hook 'eshell-mode-hook 'helm-gtags-mode)
	(add-hook 'c-mode-hook 'helm-gtags-mode)
	(add-hook 'c++-mode-hook 'helm-gtags-mode)
	(add-hook 'asm-mode-hook 'helm-gtags-mode)

	(define-key helm-gtags-mode-map (kbd "<leader> g a") 'helm-gtags-tags-in-this-function)
	(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
	(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
	(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
	(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
	(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)


(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers
(add-hook 'c-mode-common-hook
          #'(lambda () (autopair-mode)))

(use-package counsel-etags
  :ensure t
  :bind (("C-]" . counsel-etags-find-tag-at-point))
  :init
  ;; Don't ask before rereading the TAGS files if they have changed
  (setq tags-revert-without-query t)
  ;; Don't warn when TAGS files are large
  (setq large-file-warning-threshold nil)
  (add-hook 'prog-mode-hook
			(lambda ()
			  (add-hook 'after-save-hook
						'counsel-etags-virtual-update-tags 'append 'local)))
  :config
  (setq counsel-etags-update-interval 60)
  (add-to-list 'counsel-etags-ignore-directories "build"))


(eval-after-load 'counsel-etags
  '(progn
     ;; counsel-etags-ignore-directories does NOT support wildcast
     (add-to-list 'counsel-etags-ignore-directories "bin")
     ;; counsel-etags-ignore-filenames supports wildcast
     (add-to-list 'counsel-etags-ignore-filenames "TAGS")
     (add-to-list 'counsel-etags-ignore-filenames "*.json")))

(setq speedbar-show-unknown-files t)

;; markdown-mode
(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


;; org-mode
(require 'org)
(setq org-src-fontify-natively t)

;; 设置默认 Org Agenda 文件目录
(setq org-agenda-files '("/vagrant/resources/100-Work-工作资料库/110-工作计划"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;  ---------- key map ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C-o") 'pop-global-mark)
;; 设置 org-agenda 打开快捷键
(global-set-key (kbd "C-c a") 'org-agenda)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files nil)
 '(package-selected-packages
   (quote
	(company-lsp lsp-go wgrep-helm markdown-mode jumplist highlight-symbol highlight-indent-guides format-all autopair highlight-parentheses highlight multi-term spacemacs-theme fzf imenu-list eshell-fixed-prompt goto-last-change evil-escape magit helm-git dashboard-project-status dashboard find-file-in-project counsel-gtags general evil-leader evil-args geben-helm-projectile exec-path-from-shell helm company-go company-c-headers evil ggtags company swiper ace-window winum which-key use-package try))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0))))
 '(hl-line ((t (:background "RoyalBlue2")))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
(provide 'init)
;;; init.el ends here
