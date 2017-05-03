
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; el-get start
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
    (with-current-buffer
	        (url-retrieve-synchronously
			         "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
			    (goto-char (point-max))
				    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

(require 'el-get)
(add-to-list 'el-get-recipe-path "~/dev/emacs/el-get/recipes")
(setq el-get-verbose t)

;; personal recipes
(setq el-get-sources
      '((:name el-get :branch "master")

	(:name magit
	       :before (global-set-key (kbd "C-x C-z") 'magit-status))

	(:name expand-region
	       :before (global-set-key (kbd "C-@") 'er/expand-region))

	(:name descbinds-anything
	       :after (progn
			(descbinds-anything-install)
			(global-set-key (kbd "C-h b") 'descbinds-anything)))

	(:name goto-last-change
	       :before (global-set-key (kbd "C-x C-/") 'goto-last-change))

	(:name helm
	       :before (global-set-key (kbd "M-x") 'helm-M-x))

	(:name flycheck
	       :after (progn
					 (global-flycheck-mode)
					 (global-set-key [f9] 'flycheck-list-errors)))
	
	(:name smartparens
	       :before (smartparens-global-mode))
	
	(:name xcscope
	       :before (setq cscope-do-not-update-database t))
		
	(:name emacs-neotree
	       :before (global-set-key [f2] 'neotree-toggle))

	(:name color-theme
	       :after (progn
			(color-theme-initialize)
			(color-theme-solarized)))

	(:name highlight-symbol
	       :before (progn
					 (global-set-key [(shift f8)] 'highlight-symbol-at-point)
					 (global-set-key [f8] 'highlight-symbol-next)
					 (global-set-key [(f7)] 'highlight-symbol-prev)
					 (global-set-key [(control f8)] 'highlight-symbol-remove-all)
					 (global-set-key [(meta f8)] 'highlight-symbol-query-replace)))
	
	(:name yasnippet
	       :before (yas-global-mode 1))))

;; my packages
(setq dim-packages
      (append
       ;; list of packages we use straight from official recipes
       '(auto-complete find-file-in-project org-mode) 

       (mapcar 'el-get-as-symbol (mapcar 'el-get-source-name el-get-sources))))

(el-get 'sync dim-packages)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; el-get end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; global set start

;; key binding
;; copy region or whole line
(global-set-key (kbd "M-w")
(lambda ()
  (interactive)
  (if mark-active
      (kill-ring-save (region-beginning)
      (region-end))
    (progn
     (kill-ring-save (line-beginning-position)
     (line-end-position))
     (message "copied line")))))

;; kill region or whole line
(global-set-key (kbd "C-w")
(lambda ()
  (interactive)
  (if mark-active
      (kill-region (region-beginning)
   (region-end))
    (progn
     (kill-region (line-beginning-position)
  (line-end-position))
     (message "killed line")))))

(global-set-key [(f12)] 'anything-imenu)
;;(global-set-key [(f12)] 'semantic-ia-fast-jump)
(global-set-key [S-f12]
                (lambda ()
                  (interactive)
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
                      (error "Semantic Bookmark ring is currently empty"))
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))
                         (alist (semantic-mrub-ring-to-assoc-list ring))
                         (first (cdr (car alist))))
                    (if (semantic-equivalent-tag-p (oref first tag)
                                                   (semantic-current-tag))
                        (setq first (cdr (car (cdr alist)))))
                    (semantic-mrub-switch-tags first))))

;; backup files
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

;; tab settings
(setq indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-width 4)
(setq indent-line-function 'insert-tab)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120)))
 '(auto-compression-mode t nil (jka-compr))
 '(case-fold-search t)
 '(current-language-environment "Chinese-GB")
 '(default-input-method "chinese-py-punct")
 '(ecb-options-version "2.40")
 '(ecb-source-path nil)
 '(global-font-lock-mode t nil (font-lock))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; transparent settings
(global-set-key [(f6)] 'loop-alpha); alpha 
(setq alpha-list '((95 95) (100 100)))
(defun loop-alpha ()    
  (interactive)    
  (let ((h (car alpha-list)))                    
    ((lambda (a ab)    
       (set-frame-parameter (selected-frame) 'alpha (list a ab))    
       (add-to-list 'default-frame-alist (cons 'alpha (list a ab)))    
       ) (car h) (car (cdr h)))    
    (setq alpha-list (cdr (append alpha-list (list h))))    
    )    
  )
(loop-alpha)

;; font
;;(set-default-font "8x16")
(set-keyboard-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
(setq-default pathname-coding-system 'utf-8)

;; full screen
(global-set-key [f11] 'my-fullscreen)
(defun my-fullscreen ()
(interactive)
(x-send-client-message
nil 0 nil "_NET_WM_STATE" 32
'(2 "_NET_WM_STATE_FULLSCREEN" 0))
)

;; maximize
(defun my-maximized ()
(interactive)
(x-send-client-message
nil 0 nil "_NET_WM_STATE" 32
'(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
(x-send-client-message
nil 0 nil "_NET_WM_STATE" 32
'(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
)
;;(my-maximized)

;; startup window size
(setq default-frame-alist
      '((height . 37) (width . 160) (menu-bar-lines . 20) (tool-bar-lines . 0))) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; global set end
