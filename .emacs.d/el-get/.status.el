((anything status "installed" recipe
	   (:name anything :website "http://www.emacswiki.org/emacs/Anything" :description "Open anything / QuickSilver-like candidate-selection framework" :type git :url "http://repo.or.cz/r/anything-config.git" :shallow nil :load-path
		  ("." "extensions" "contrib")
		  :features anything))
 (auto-complete status "installed" recipe
		(:name auto-complete :website "https://github.com/auto-complete/auto-complete" :description "The most intelligent auto-completion extension." :type github :pkgname "auto-complete/auto-complete" :depends
		       (popup fuzzy)
		       :features auto-complete-config :post-init
		       (progn
			 (add-to-list 'ac-dictionary-directories
				      (expand-file-name "dict" default-directory))
			 (ac-config-default))))
 (cl-lib status "installed" recipe
	 (:name cl-lib :builtin "24.3" :type elpa :description "Properly prefixed CL functions and macros" :website "http://elpa.gnu.org/packages/cl-lib.html"))
 (dash status "installed" recipe
       (:name dash :description "A modern list api for Emacs. No 'cl required." :type github :pkgname "magnars/dash.el"))
 (descbinds-anything status "installed" recipe
		     (:name descbinds-anything :after
			    (progn
			      (descbinds-anything-install)
			      (global-set-key
			       (kbd "C-h b")
			       'descbinds-anything))
			    :description "Yet Another describe-bindings with anything" :type emacswiki :depends anything :features descbinds-anything))
 (el-get status "installed" recipe
	 (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "master" :pkgname "dimitri/el-get" :info "." :compile
		("el-get.*\\.el$" "methods/")
		:features el-get :post-init
		(when
		    (memq 'el-get
			  (bound-and-true-p package-activated-list))
		  (message "Deleting melpa bootstrap el-get")
		  (unless package--initialized
		    (package-initialize t))
		  (when
		      (package-installed-p 'el-get)
		    (let
			((feats
			  (delete-dups
			   (el-get-package-features
			    (el-get-elpa-package-directory 'el-get)))))
		      (el-get-elpa-delete-package 'el-get)
		      (dolist
			  (feat feats)
			(unload-feature feat t))))
		  (require 'el-get))))
 (emacs-async status "installed" recipe
	      (:name emacs-async :description "Simple library for asynchronous processing in Emacs" :type github :pkgname "jwiegley/emacs-async"))
 (emacs-neotree status "installed" recipe
		(:name emacs-neotree :before
		       (global-set-key
			[f2]
			'neotree-toggle)
		       :description "A emacs tree plugin like NerdTree for Vim." :website "https://github.com/jaypei/emacs-neotree" :type github :pkgname "jaypei/emacs-neotree"))
 (epl status "installed" recipe
      (:name epl :description "EPL provides a convenient high-level API for various package.el versions, and aims to overcome its most striking idiocies." :type github :pkgname "cask/epl"))
 (expand-region status "installed" recipe
		(:name expand-region :before
		       (global-set-key
			(kbd "C-@")
			'er/expand-region)
		       :type github :pkgname "magnars/expand-region.el" :description "Expand region increases the selected region by semantic units. Just keep pressing the key until it selects what you want." :website "https://github.com/magnars/expand-region.el#readme"))
 (find-file-in-project status "installed" recipe
		       (:name find-file-in-project :type github :pkgname "technomancy/find-file-in-project" :description "Quick access to project files in Emacs"))
 (flycheck status "installed" recipe
	   (:name flycheck :after
		  (progn
		    (global-flycheck-mode)
		    (global-set-key
		     [f9]
		     'flycheck-list-errors))
		  :type github :pkgname "flycheck/flycheck" :minimum-emacs-version "24.3" :description "On-the-fly syntax checking extension" :depends
		  (dash pkg-info let-alist seq)))
 (fuzzy status "installed" recipe
	(:name fuzzy :website "https://github.com/auto-complete/fuzzy-el" :description "Fuzzy matching utilities for GNU Emacs" :type github :pkgname "auto-complete/fuzzy-el"))
 (ghub status "installed" recipe
       (:name ghub :type github :description "Minuscule client for the Github API" :pkgname "magit/ghub" :depends
	      (graphql treepy)))
 (goto-last-change status "installed" recipe
		   (:name goto-last-change :before
			  (global-set-key
			   (kbd "C-x C-/")
			   'goto-last-change)
			  :description "Move point through buffer-undo-list positions" :type emacswiki :load "goto-last-change.el"))
 (graphql status "installed" recipe
	  (:name graphql :description "GraphQL.el provides a set of generic functions for interacting with GraphQL web services." :type github :pkgname "vermiculus/graphql.el"))
 (helm status "installed" recipe
       (:name helm :before
	      (global-set-key
	       (kbd "M-x")
	       'helm-M-x)
	      :description "Emacs incremental completion and narrowing framework" :type github :pkgname "emacs-helm/helm" :autoloads "helm-autoloads" :build
	      `(("make" ,(concat "ASYNC_ELPA_DIR="
				 (el-get-package-directory 'emacs-async))))
	      :depends
	      (emacs-async)
	      :build/darwin
	      `(("make" ,(concat "ASYNC_ELPA_DIR="
				 (el-get-package-directory 'emacs-async))
		 ,(format "EMACS_COMMAND=%s" el-get-emacs)))
	      :build/windows-nt
	      (let
		  ((generated-autoload-file
		    (expand-file-name "helm-autoloads.el"))
		   \
		   (backup-inhibited t))
	      (update-directory-autoloads default-directory)
	      nil)
       :build/berkeley-unix
       `(("gmake" ,(concat "ASYNC_ELPA_DIR="
			   (el-get-package-directory 'emacs-async))))
       :features "helm-config" :post-init
       (helm-mode)))
(highlight-symbol status "installed" recipe
(:name highlight-symbol :before
(progn
(global-set-key
[(shift f8)]
'highlight-symbol-at-point)
(global-set-key
[f8]
'highlight-symbol-next)
(global-set-key
[(f7)]
'highlight-symbol-prev)
(global-set-key
[(control f8)]
'highlight-symbol-remove-all)
(global-set-key
[(meta f8)]
'highlight-symbol-query-replace))
:description "Quickly highlight a symbol throughout the buffer and cycle through its locations." :type github :pkgname "nschum/highlight-symbol.el"))
(let-alist status "installed" recipe
(:name let-alist :description "Easily let-bind values of an assoc-list by their names." :builtin "25.0.50" :type elpa :website "https://elpa.gnu.org/packages/let-alist.html"))
(magit status "installed" recipe
(:name magit :before
(global-set-key
(kbd "C-x C-z")
'magit-status)
:website "https://github.com/magit/magit#readme" :description "It's Magit! An Emacs mode for Git." :type github :pkgname "magit/magit" :branch "master" :minimum-emacs-version "24.4" :depends
(dash emacs-async ghub let-alist magit-popup with-editor)
:info "Documentation" :load-path "lisp/" :compile "lisp/" :build
`(("make" ,(format "EMACSBIN=%s" el-get-emacs)
"docs")
("touch" "lisp/magit-autoloads.el"))
:build/berkeley-unix
`(("gmake" ,(format "EMACSBIN=%s" el-get-emacs)
"docs")
("touch" "lisp/magit-autoloads.el"))
:build/windows-nt
(with-temp-file "lisp/magit-autoloads.el" nil)))
(magit-popup status "installed" recipe
(:name magit-popup :website "https://github.com/magit/magit-popup" :description "Define prefix-infix-suffix command combos" :type github :pkgname "magit/magit-popup" :depends
(emacs-async dash)))
(org-mode status "required" recipe nil)
(pkg-info status "installed" recipe
(:name pkg-info :description "Provide information about Emacs packages." :type github :pkgname "lunaryorn/pkg-info.el" :depends
(dash epl)))
(popup status "installed" recipe
(:name popup :website "https://github.com/auto-complete/popup-el" :description "Visual Popup Interface Library for Emacs" :type github :submodule nil :depends cl-lib :pkgname "auto-complete/popup-el"))
(seq status "installed" recipe
(:name seq :description "Sequence manipulation functions" :builtin "25" :type elpa :website "https://elpa.gnu.org/packages/seq.html"))
(smartparens status "installed" recipe
(:name smartparens :before
(smartparens-global-mode)
:description "Autoinsert pairs of defined brackets and wrap regions" :type github :pkgname "Fuco1/smartparens" :depends dash))
(treepy status "installed" recipe
(:name treepy :description "A set of generic functions for traversing tree-like data structures recursively and/or iteratively." :type github :pkgname "volrath/treepy.el"))
(with-editor status "installed" recipe
(:name with-editor :description "Use the Emacsclient as $EDITOR" :type github :pkgname "magit/with-editor"))
(xcscope status "installed" recipe
(:name xcscope :before
(setq cscope-do-not-update-database t)
:description "Cscope interface for (X)Emacs" :type github :pkgname "dkogan/xcscope.el" :prepare
(progn
(add-hook 'c-mode-hook #'cscope-minor-mode)
(add-hook 'c++-mode-hook #'cscope-minor-mode)
(add-hook 'dired-mode-hook #'cscope-minor-mode))))
(yasnippet status "installed" recipe
(:name yasnippet :before
(yas-global-mode 1)
:website "https://github.com/capitaomorte/yasnippet.git" :description "YASnippet is a template system for Emacs." :type github :pkgname "capitaomorte/yasnippet" :compile "yasnippet.el" :submodule nil)))
