;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Brayden Moon"
      user-mail-address "brayden.moon@cba.com.au")

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
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tomorrow-night)

;; Change font
(setq doom-font (font-spec :family "MonoLisaVariable Nerd Font" :size 18))

;; (add-to-list 'deafult-frame-alist '(alpha . 90))

;;(custom-set-face
;; '(default ((t (:background "#000000"))))
;; '(hl-line ((t (:background "#000000"))))
;;)

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

;; Enable auto save and backups
(setq auto-save-default t
      make-backup-files t)

;; Disable exit confirmation
(setq confirm-kill-emacs nil)

;; Copilot setup
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))


;; Custom splash screen
(defun angel-art ()
  (let* ((banner '("         .m.                                   ,_"
                   "         ' ;M;                                ,;m `"
                   "           ;M;.           ,      ,           ;SMM;"
                   "          ;;Mm;         ,;  ____  ;,         ;SMM;"
                   "         ;;;MM;        ; (.MMMMMM.) ;       ,SSMM;;"
                   "       ,;;;mMp'        l  ';mmmm;/  j       SSSMM;;"
                   "     .;;;;;MM;         .\\,.mmSSSm,,/,      ,SSSMM;;;"
                   "    ;;;;;;mMM;        .;MMmSSSSSSSmMm;     ;MSSMM;;;;"
                   "   ;;;;;;mMSM;     ,_ ;MMmS;;;;;;mmmM;  -,;MMMMMMm;;;;"
                   "  ;;;;;;;MMSMM;     \\\"*;M;( ( '') );m;*\"/ ;MMMMMM;;;;;,"
                   " .;;;;;;mMMSMM;      \\(@;! _     _ !;@)/ ;MMMMMMMM;;;;;,"
                   " ;;;;;;;MMSSSM;       ;,;.*o*> <*o*.;m; ;MMMMMMMMM;;;;;;,"
                   ".;;;;;;;MMSSSMM;     ;Mm;           ;M;,MMMMMMMMMMm;;;;;;."
                   ";;;;;;;mmMSSSMMMM,   ;Mm;,   '-    ,;M;MMMMMMMSMMMMm;;;;;;;"
                   ";;;;;;;MMMSSSMMMMMMMm;Mm;;,  ___  ,;SmM;MMMMMMSSMMMM;;;;;;;;"
                   ";;'\";;;MMMSSSSMMMMMM;MMmS;;,  \"  ,;SmMM;MMMMMMSSMMMM;;;;;;;;."
                   "!   ;;;MMMSSSSSMMMMM;MMMmSS;;._.;;SSmMM;MMMMMMSSMMMM;;;;;;;;;"
                   "    ;;;;*MSSSSSSMMMP;Mm*\"'q;'   `;p*\"*M;MMMMMSSSSMMM;;;;;;;;;"
                   "    ';;;  ;SS*SSM*M;M;'     `-.        ;;MMMMSSSSSMM;;;;;;;;;,"
                   "     ;;;. ;P  `q; qMM.                 ';MMMMSSSSSMp' ';;;;;;;"
                   "     ;;;; ',    ; .mm!     \\.   `.   /  ;MMM' `qSS'    ';;;;;;;"
                   "     ';;;       ' mmS';     ;     ,  `. ;'M'   `S       ';;;;;"
                   "      `;;.        mS;;`;    ;     ;    ;M,!     '        ';;;;"
                   "       ';;       .mS;;, ;   '.    ;    MM;                ;;;;"
                   "        ';;      MMmS;; `,   ;._.' -_.'MM;                 ;;;"
                   "         `;;     MMmS;;; ;   ;      ;  MM;                 ;;;"
                   "           `'.   'MMmS;; `;) ',    .' ,M;'                 ;;;"
                   "              \\    '' ''; ;   ;    ;  ;'                   ;;"
                   "               ;        ; `,  ;    ;  ;                   ;;"
                   "                        |. ;  ; (. ;  ;      _.-.         ;;"
                   "           .-----..__  /   ;  ;   ;' ;\\  _.-\" .- `.      ;;"
                   "         ;' ___      `*;   `; ';  ;  ; ;'  .-'    :      ;"
                   "         ;     \"\"\"*-.   `.  ;  ;  ;  ; ' ,'      /       |"
                   "         ',          `-_    (.--',`--'..'      .'        ',"
                   "           `-_          `*-._'.\\\\\\;||\\\\)     ,'"
                   "              `\"*-._        \"*`-ll_ll'l    ,'"
                   "                 ,==;*-._           \"-.  .'"
                   "              _-'    \"*-=`*;-._        ;'"
                   "            .\"            ;'  ;\"*-.    `"
                   "            ;   ____      ;//'     \"-   `,"
                   "            `+   .-/                 \".\\\\"
                   "              `*\" /                    \"'"))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat line (make-string (max 0 (- longest-line (length line))) 32)))
               "\n"))
     'face 'doom-dashboard-banner)))

;; Setting the splash screen
(setq +doom-dashboard-ascii-banner-fn #'angel-art)

;; Adding the vi '%' mode.
(after! smartparens
  (defun zz/goto-match-paren (arg)
    "Go to the matching paren/bracket, otherwise (or if ARG is not
    nil) insert %.  vi style of % jumping to matching brace."
    (interactive "p")
    (if (not (memq last-command '(set-mark
                                  cua-set-mark
                                  zz/goto-match-paren
                                  down-list
                                  up-list
                                  end-of-defun
                                  beginning-of-defun
                                  backward-sexp
                                  forward-sexp
                                  backward-up-list
                                  forward-paragraph
                                  backward-paragraph
                                  end-of-buffer
                                  beginning-of-buffer
                                  backward-word
                                  forward-word
                                  mwheel-scroll
                                  backward-word
                                  forward-word
                                  mouse-start-secondary
                                  mouse-yank-secondary
                                  mouse-secondary-save-then-kill
                                  move-end-of-line
                                  move-beginning-of-line
                                  backward-char
                                  forward-char
                                  scroll-up
                                  scroll-down
                                  scroll-left
                                  scroll-right
                                  mouse-set-point
                                  next-buffer
                                  previous-buffer
                                  previous-line
                                  next-line
                                  back-to-indentation
                                  doom/backward-to-bol-or-indent
                                  doom/forward-to-last-non-comment-or-eol
                                  )))
        (self-insert-command (or arg 1))
      (cond ((looking-at "\\s\(") (sp-forward-sexp) (backward-char 1))
            ((looking-at "\\s\)") (forward-char 1) (sp-backward-sexp))
            (t (self-insert-command (or arg 1))))))
  (map! "%" 'zz/goto-match-paren))

;; Mass rename in code
(use-package! iedit
  :defer
  :config
  (set-face-background 'iedit-occurence "Magneta")
  :bind
  ("C-;" . iedit-mode))

;; Mac modifier keys
(cond (IS-MAC
       (setq mac-command-modifier       'meta
             mac-option-modifier        'alt
             mac-right-option-modifier  'alt
             mac-pass-control-to-system nil)))

;; Remove whole line rather than just emptying it.
(setq kill-whole-line t)

;; Remove menu items from main menu
(setq +doom-dashboard-menu-sections (cl-subseq +doom-dashboard-menu-sections 0 2))

;; Fix missing ligatures
(plist-put! +ligatures-extra-symbols
            :and nil
            :or nil
            :for nil
            :not nil
            :int nil
            :float nil
            :str nil
            :bool nil
            :list nil)

(let ((ligatures-to-disable '(:int :float :str :bool :list :and :or :for :not)))
  (dolist (sym ligatures-to-disable)
    (plist-put! +ligatures-extra-symbols sym nil))
  )

;; Setup golang
;; source: https://nayak.io/posts/golang-development-doom-emacs/
;; golang formatting set up
;; use gofumpt
(after! lsp-mode
  (setq  lsp-go-use-gofumpt t)
  )
;; automatically organize imports
(add-hook 'go-mode-hook #'lsp-deferred)
;; Make sure you don't have other goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; enable all analyzers; not done by default
(after! lsp-mode
  (setq  lsp-go-analyses '((fieldalignment . t)
                           (nilness . t)
                           (shadow . t)
                           (unusedparams . t)
                           (unusedwrite . t)
                           (useany . t)
                           (unusedvariable . t)))
  )

;; Toggle comment on line
(map! :leader
      :desc "Comment or uncomment lines"        "TAB TAB" #'comment-line)

;; Mapping move-text-up and move-text-down to OPTION + UP and OPTION + DOWN
(map! "<M-up>" #'my-move-text-up
      "<M-down>" #'my-move-text-down)

;; Telling move-text-up and move-text-down to indent the region after moving
(defun indent-region-advice (&rest ignored)
  (let ((deactivate deactivate-mark))
    (if (region-active-p)
        (indent-region (region-beginning) (region-end))
      (indent-region (line-beginning-position) (line-end-position)))
    (setq deactivate-mark deactivate)))

(advice-add 'move-text-up :after 'indent-region-advice)
(advice-add 'move-text-down :after 'indent-region-advice)
