;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font" :size 14))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;
;; Custom Configuration
;;

;;
;; Visual Enhancements
;;

;; Icons configuration (nerd-icons)
(after! nerd-icons
  (setq nerd-icons-scale-factor 1.1
        nerd-icons-default-adjust 0.0))

;; Doom modeline enhancements
(after! doom-modeline
  (setq doom-modeline-height 30
        doom-modeline-bar-width 4
        doom-modeline-buffer-file-name-style 'truncate-upto-project
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-buffer-state-icon t
        doom-modeline-buffer-modification-icon t
        doom-modeline-unicode-fallback nil
        doom-modeline-minor-modes nil
        doom-modeline-enable-word-count nil
        doom-modeline-buffer-encoding t
        doom-modeline-indent-info nil
        doom-modeline-checker-simple-format t
        doom-modeline-vcs-max-length 12
        doom-modeline-env-version t
        doom-modeline-lsp t
        doom-modeline-github nil
        doom-modeline-modal-icon t
        doom-modeline-workspace-name t))

;; Dashboard configuration
(setq fancy-splash-image (concat doom-user-dir "splash.png"))  ; Add custom splash image if desired
(setq +doom-dashboard-banner-padding '(0 . 2))

(after! doom-dashboard
  (setq dashboard-banner-logo-title "Welcome to Doom Emacs"
        dashboard-center-content t
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name))

;; Transparency (matching your Alacritty config)
(set-frame-parameter nil 'alpha-background 95)
(add-to-list 'default-frame-alist '(alpha-background . 95))

;; Solaire mode for better buffer distinction
(solaire-global-mode +1)

;; Indent guides customization
(after! highlight-indent-guides
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-character ?\┊
        highlight-indent-guides-responsive 'top
        highlight-indent-guides-auto-enabled t
        highlight-indent-guides-auto-odd-face-perc 15
        highlight-indent-guides-auto-even-face-perc 15
        highlight-indent-guides-auto-character-face-perc 20))

;; Better window selection visualization
(after! ace-window
  (setq aw-scope 'frame
        aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
        aw-minibuffer-flag t))

;; Treemacs visual improvements
(after! treemacs
  (setq treemacs-width 35
        treemacs-indentation 2
        treemacs-follow-mode t
        treemacs-filewatch-mode t
        treemacs-fringe-indicator-mode 'always
        treemacs-git-mode 'deferred
        treemacs-project-follow-mode t)  ; Auto-switch to current project

  ;; Automatically update treemacs root when switching projects
  (add-hook 'projectile-after-switch-project-hook
            (lambda ()
              (when (treemacs-current-visibility)
                (treemacs-add-and-display-current-project)))))

;; Nav-flash settings for better visual feedback
(after! nav-flash
  (setq nav-flash-delay 0.3))

;; Better line highlighting
(setq global-hl-line-modes t)

;; Show matching parentheses with minimal delay
(setq show-paren-delay 0.0
      show-paren-style 'mixed
      show-paren-when-point-inside-paren t
      show-paren-when-point-in-periphery t)

;; Smooth scrolling
(setq scroll-margin 3
      scroll-conservatively 101
      scroll-preserve-screen-position t
      auto-window-vscroll nil)

;; Enhanced hl-todo configuration
(after! hl-todo
  (setq hl-todo-keyword-faces
        '(("TODO"   . "#d79921")  ; Gruvbox yellow
          ("FIXME"  . "#fb4934")  ; Gruvbox red
          ("DEBUG"  . "#fe8019")  ; Gruvbox orange
          ("GOTCHA" . "#fb4934")  ; Gruvbox red
          ("STUB"   . "#b8bb26")  ; Gruvbox green
          ("NOTE"   . "#83a598")  ; Gruvbox blue
          ("HACK"   . "#fabd2f")  ; Gruvbox yellow-orange
          ("REVIEW" . "#8ec07c")  ; Gruvbox aqua
          ("DEPRECATED" . "#fb4934"))))  ; Gruvbox red

;; Zen mode for distraction-free coding
(after! writeroom-mode
  (setq writeroom-width 120
        writeroom-mode-line t
        writeroom-maximize-window nil))

;; LSP Configuration
(after! lsp-mode
  (setq lsp-headerline-breadcrumb-enable t
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t
        lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-lens-enable t
        lsp-signature-auto-activate t
        lsp-signature-render-documentation t))

;; Go configuration
;; Ensure .go files activate go-mode
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

(after! go-mode
  ;; Use asdf-managed goimports
  (setq gofmt-command (expand-file-name "~/.asdf/installs/golang/1.23.5/bin/goimports"))

  ;; Format on save (buffer-local hook to avoid conflicts)
  (add-hook 'go-mode-hook
            (lambda ()
              (add-hook 'before-save-hook 'gofmt-before-save nil t)))

  ;; Set GOPATH for asdf
  (setenv "GOPATH" (expand-file-name "~/go"))
  (add-to-list 'exec-path (expand-file-name "~/go/bin"))
  (add-to-list 'exec-path (expand-file-name "~/.asdf/installs/golang/1.23.5/bin")))

;; Python configuration
(after! python
  (setq python-shell-interpreter "python3"
        python-indent-guess-indent-offset-verbose nil))

;; JavaScript/TypeScript configuration
(after! js2-mode
  (setq js-indent-level 2
        js2-basic-offset 2
        js2-strict-missing-semi-warning nil))

(after! typescript-mode
  (setq typescript-indent-level 2))

;; Company (completion) settings
(after! company
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 2
        company-show-quick-access t))

;; Projectile settings
(after! projectile
  (setq projectile-project-search-path '("~/projects/" "~/work/")))

;; Enable format on save for supported modes
(add-hook 'go-mode-hook 'lsp-format-buffer-on-save)
(add-hook 'python-mode-hook 'lsp-format-buffer-on-save)
(add-hook 'js2-mode-hook 'lsp-format-buffer-on-save)
(add-hook 'typescript-mode-hook 'lsp-format-buffer-on-save)

;; Treemacs keybindings (integrated with which-key)
(map! :leader
      :desc "Toggle treemacs" "o p" #'treemacs
      :desc "Select treemacs window" "o P" #'treemacs-select-window)

;; Toggle bindings for visual features
(map! :leader
      (:prefix ("t" . "toggle")
       :desc "Treemacs" "p" #'treemacs
       :desc "Rainbow mode" "r" #'rainbow-mode
       :desc "Zen mode" "z" #'+zen/toggle
       :desc "Indent guides" "i" #'highlight-indent-guides-mode
       :desc "Line numbers" "l" #'doom/toggle-line-numbers))

;;
;; Testing and Building Configuration
;;

;; Define helper functions for common make targets
(defun makefile-runner-test ()
  "Run 'make test' in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "make test")))

(defun makefile-runner-lint ()
  "Run 'make lint' in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "make lint")))

(defun makefile-runner-build ()
  "Run 'make build' in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "make build")))

(defun makefile-runner-all ()
  "Run 'make all' in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "make all")))

;; Testing and Building keybindings (global leader)
(map! :leader
      (:prefix ("c" . "code")
       :desc "Compile/Make" "c" #'projectile-compile-project
       :desc "Recompile" "C" #'recompile
       :desc "Make test" "t" #'makefile-runner-test
       :desc "Make lint" "l" #'makefile-runner-lint
       :desc "Make build" "b" #'makefile-runner-build
       :desc "Make all" "m" #'makefile-runner-all))

;; Quick test runners for specific languages (local leader)
(map! :localleader
      :map go-mode-map
      :desc "Run tests" "t" #'makefile-runner-test
      :desc "Run lint" "l" #'makefile-runner-lint
      :desc "Build" "b" #'makefile-runner-build)

(map! :localleader
      :map python-mode-map
      :desc "Run tests" "t" #'makefile-runner-test
      :desc "Run lint" "l" #'makefile-runner-lint
      :desc "Build" "b" #'makefile-runner-build)

;;
;; Terraform Configuration
;;

;; Terraform helper functions
(defun terraform-init ()
  "Run 'terraform init' in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "terraform init")))

(defun terraform-plan ()
  "Run 'terraform plan' in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "terraform plan")))

(defun terraform-apply ()
  "Run 'terraform apply' in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "terraform apply")))

(defun terraform-destroy ()
  "Run 'terraform destroy' in project root."
  (interactive)
  (when (yes-or-no-p "Really destroy infrastructure? ")
    (let ((default-directory (projectile-project-root)))
      (compile "terraform destroy"))))

(defun terraform-validate ()
  "Run 'terraform validate' in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "terraform validate")))

(defun terraform-fmt-buffer ()
  "Run 'terraform fmt' on current file."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (shell-command (format "terraform fmt %s" (buffer-file-name)))
    (revert-buffer t t t)))

;; Terraform keybindings in terraform-mode
(map! :localleader
      :map terraform-mode-map
      :desc "Init" "i" #'terraform-init
      :desc "Plan" "p" #'terraform-plan
      :desc "Apply" "a" #'terraform-apply
      :desc "Destroy" "d" #'terraform-destroy
      :desc "Validate" "v" #'terraform-validate
      :desc "Format buffer" "f" #'terraform-fmt-buffer)

;; Auto-format terraform files on save
(after! terraform-mode
  (add-hook 'terraform-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'terraform-fmt-buffer nil t))))

;; Configure compilation buffer behavior
(after! compile
  (setq compilation-scroll-output t
        compilation-always-kill t
        compilation-ask-about-save nil))

;; Claude Code IDE integration
(use-package! claude-code-ide
  :bind ("C-c C-'" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup))

;;
;; YAML Configuration
;;

(after! yaml-mode
  ;; Clean up whitespace on save
  (add-hook 'yaml-mode-hook
            (lambda ()
              (add-hook 'before-save-hook 'delete-trailing-whitespace nil t)))

  ;; Indentation settings
  (setq yaml-indent-offset 2))
