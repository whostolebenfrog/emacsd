(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                                        (not (gnutls-available-p))))
              (proto (if no-ssl "http" "https")))
    ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
      (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
        ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
          (when (< emacs-major-version 24)
                ;; For important compatibility libraries like cl-lib
                    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; Vim mode
(require 'evil)
(evil-mode 1)

;; Not sure why I'm loading these like this but it's kind of handy
(add-to-list 'load-path "~/.emacs.d/small-plugins")

;; evil numbers (inc and dec)
(require 'evil-numbers)
(define-key evil-normal-state-map (kbd "C-x a") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-x x") 'evil-numbers/dec-at-pt)

;; evil surround
(require 'evil-surround)
(global-evil-surround-mode 1)

;; goto last change e.g. `.
(require 'goto-last-change)

;; not sure why I set this...
(put 'downcase-region 'disabled nil)

;; evil leader set to ,
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader ",")

;; don't use prefix notation when formatting ns.
(setq cljr-favor-prefix-notation nil)

;; Popup windows - handy for a quick REPL popup
(require 'popwin)
(popwin-mode 1)

;; Show the repl in a popwin (popup) buffer that can be closed with ctrl-g
(defun popup-repl ()
  (interactive)
  (popwin:popup-buffer "*cider-repl 127.0.0.1*"))

;; Default the repl to opening in said popwin buffer
(push '("*cider-repl localhost*" :position bottom) popwin:special-display-config)

(setq-default
  evil-symbol-word-search t)

(defun eval-show-clean-repl ()
  (interactive)
  (cider-find-and-clear-repl-buffer)
  (sleep-for 5)
  (cider-eval-last-sexp)
  (popup-repl))

;; Jump between more matching things - probably needs updating...
(require 'evil-matchit)
(global-evil-matchit-mode 1)

;; Not sure I will still need these. I think find-file-in-project is probably what I need
(setq-default abbrev-mode t)
(define-abbrev global-abbrev-table "cc" "~/workspace/neo4j-ingester/resources/cypher")
(define-abbrev global-abbrev-table "ss" "~/workspace/neo4j-ingester/src/com/atomist/ingester/neo4j_ingester")
(define-abbrev global-abbrev-table "ee" "~/workspace/neo4j-ingester/test/com/atomist/ingester/neo4j_ingester/end_to_end")
(define-abbrev global-abbrev-table "tt" "~/workspace/neo4j-ingester/test/com/atomist/ingester/neo4j_ingester")
(define-abbrev global-abbrev-table "pp" "~/workspace/neo4j-ingester/src/com/atomist/ingester/neo4j_ingester/packs")

;; working vars
;(define-abbrev global-abbrev-table "at" "{{atm-team-id}}_")

(load-theme 'cyberpunk t)

;; Pretty brackets
(require 'rainbow-delimiters)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

;; fixed brackets, barf spit etc
(require 'paredit)
(add-hook 'clojure-mode-hook #'paredit-mode)

;; Otherwise you get a stupid menu that you can't click because it's a terminal
(menu-bar-mode -1)

;; Does autocomplete stuff in a popup in the source. Works with CIDER
(require 'company)
(global-company-mode)

;; Provides function sigs in the echo buffer (line right at the bottom)
(require 'cider-eldoc)
(add-hook 'cider-mode-hook #'eldoc-mode)

;; Makes things auto coplete
(require 'icomplete)

;; Does fuzzy file matching etc. Pretty cool. Bound to leader F
(require 'find-file-in-project)

;; Highlight the matching paren from the one we are on
(show-paren-mode)

;; Support CamelCase for foward word etc. Good for occasional java interop
(add-hook 'clojure-mode-hook #'subword-mode)

;; Bind things with evil goodness
(evil-leader/set-key
  "f" 'cljr-clean-ns
  "F" 'find-file-in-project
  "c" 'cljr-cycle-coll
  "q" 'cider-connect
  "u" 'cljr-find-usages
  "p" 'cljr-sort-project-dependencies
  "r" 'popup-repl
  "s" 'ispell-word
  "j" 'cider-find-var
  "z" 'cider-find-and-clear-repl-buffer
  "w" 'cljr-rename-symbol
  "R" 'eval-show-clean-repl
  "t" 'cider-test-run-test
  "T" 'cider-test-run-tests)
