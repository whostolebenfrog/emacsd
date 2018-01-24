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

(require 'evil)
(evil-mode 1)

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

(put 'downcase-region 'disabled nil)

;; evil leader
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader ",")

;; don't use prefix notation when formatting ns.
(setq cljr-favor-prefix-notation nil)

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

;;
(defun eval-show-clean-repl ()
  (interactive)
  (cider-find-and-clear-repl-buffer)
  (sleep-for 5)
  (cider-eval-last-sexp)
  (popup-repl))

(require 'evil-matchit)
(global-evil-matchit-mode 1)

(setq-default abbrev-mode t)
(define-abbrev global-abbrev-table "cc" "~/workspace/neo4j-ingester/resources/cypher")
(define-abbrev global-abbrev-table "ss" "~/workspace/neo4j-ingester/src/com/atomist/ingester/neo4j_ingester")
(define-abbrev global-abbrev-table "ee" "~/workspace/neo4j-ingester/test/com/atomist/ingester/neo4j_ingester/end_to_end")
(define-abbrev global-abbrev-table "tt" "~/workspace/neo4j-ingester/test/com/atomist/ingester/neo4j_ingester")
(define-abbrev global-abbrev-table "pp" "~/workspace/neo4j-ingester/src/com/atomist/ingester/neo4j_ingester/packs")

;; working vars
;(define-abbrev global-abbrev-table "at" "{{atm-team-id}}_")

(load-theme 'cyberpunk t)

(require 'rainbow-delimiters)

(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

(require 'paredit)
(add-hook 'clojure-mode-hook #'paredit-mode)

(menu-bar-mode -1)

;; Does autocomplete stuff in a popup in the source. Works with CIDER
(require 'company)
(global-company-mode)

;; Provides function sigs in the echo buffer (line right at the bottom)
(require 'cider-eldoc)
(add-hook 'cider-mode-hook #'eldoc-mode)

;; Makes things auto coplete
(require 'icomplete)

;; 
(require 'find-file-in-project)

(show-paren-mode)

(add-hook 'clojure-mode-hook #'subword-mode)

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
