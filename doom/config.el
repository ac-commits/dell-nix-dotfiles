;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(setq fancy-splash-image (expand-file-name "assets/blackhole-lines.svg" doom-user-dir))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Alex Crom"
      user-mail-address "")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
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

;; When you want to profile your startup time
;; (use-package! benchmark-init
;;   :ensure t
;;   :config
;;   (add-hook 'doom-first-input-hook #'benchmark-init/deactivate))


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'catppuccin)

(setq
 default-font "JetBrainsMono Nerd Font"
 default-font-size 16.0
 default-nice-size 12.0
 doom-font-increment 1
 doom-font (font-spec :family default-font
                      :size default-font-size)
 doom-unicode-font (font-spec :family default-font
                              :size default-font-size))

(defvar *is-light* nil)
(defun arjen/toggle-theme()
  (interactive)
  (if *is-light*
      (progn
        (setq *is-light* nil)
        (setq catppuccin-flavor 'latte) ;; or 'latte, 'macchiato, or 'mocha
        (catppuccin-reload))

    (progn
      (setq *is-light* t)
      (setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'mocha
      (catppuccin-reload))))


(global-set-key [f5] 'arjen/toggle-theme)



;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/stack/roam/")
(setq org-roam-directory "~/stack/roam/")


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

;; The default `jk' escape sequence interferes with the dutch language.
(after! evil-escape
  (setq evil-escape-key-sequence "qp"))

(after! lsp-ui
  (setq lsp-ui-sideline-enable nil)
  (setq lsp-ui-sideline-show-code-actions nil)
  (setq lsp-ui-sideline-enable nil))

;; Org-reveal
(use-package! ox-reveal
  :config
  (setq org-reveal-root "/home/alex/.local/revealjs/")
  (setq org-reveal-theme "white")
  (add-hook 'org-export-before-processing-hook
            (lambda (backend)
              (when (eq backend 'reveal.js)))))
(setq org-reveal-extra-css "/home/alex/.local/revealjs/custom/custom.css")
(setq org-reveal-highlight-css "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.1.2/styles/night-owl.min.css")
;; (setq org-reveal-highlight-css "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/styles/github.min.css")
(setq org-export-default-author "Alex Crom")
(setq org-reveal-title-slide
      "<section class='title-slide'>
           <h1>%t</h1>
         </section>")


;;(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(add-to-list 'load-path "/home/alex/.nix-profile/share/emacs/site-lisp/mu4e")
(after! mu4e
  ;; Mail configuration
  ;; add to $DOOMDIR/config.el

  (setq sendmail-program (executable-find "msmtp")
        send-mail-function #'smtpmail-send-it
        message-sendmail-f-is-evil t
        mu4e-context-policy 'ask
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail))


(set-email-account! "GMail"
                    '((mu4e-sent-folder       . "/fm/Sent Items")
                      (mu4e-drafts-folder     . "/fm/Drafts")
                      (mu4e-trash-folder      . "/fm/Trash")
                      (mu4e-refile-folder     . "/fm/Archive")
                      (smtpmail-smtp-user     . "example@example.com")
                      (user-mail-address      . "example@exaple.com")    ;; only needed for mu < 1.4
                      (mu4e-compose-signature . "---\nYours truly\nThe Baz"))
                    t)


(use-package! org-roam
  :config
  (setq org-roam-capture-ref-templates '(("r"
                                          "ref" plain "* Notes

- ${body}%?

* Key takeaways

-

* Quotes

#+begin_quote
#+end_quote

* Summary
"
                                          :if-new
                                          (file+head "links/${slug}.org"
                                                     "#+title: ${title}\n#+filetags: :reading:notstarted:\n")
                                          :unnarrowed t)
                                         ("c"
                                          "collection" entry "** ${title}\n:PROPERTIES:\n:ID: %(org-id-uuid)\n:ROAM_REFS: ${ref}\n:END:"
                                          :target (file+olp "links/collection.org" ("Inbox"))
                                          :unnarrowed t)))

  (setq org-roam-capture-templates
        '(("m"
           "main" plain
           "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("w"
           "writeups" plain "* Synopsys %?\n\n\n* Reconnaissance %?\n\n\n* Foothold %?\n\n\n* Lessens Learned %?\n\n"
           :if-new
           (file+head "writeups/%<%Y%m%d%H%M%S>-${slug}.org"
                      "#+title: ${title}\n#+filetags: :area:writeups:\n")
           :unnarrowed t)
          ("p"
           "papers" plain "%?"
           :if-new
           (file+head "papers/%<%Y%m%d%H%M%S>-${citar-citekey}-${citar-date}.org"
                      "#+title: ${citar-citekey} (${citar-date}). ${note-title}.\n#+created: %U\n#+last_modified: %U\n#+filetags: :paper:bib:\n\n\n")
           :unnarrowed t)
          ("h"
           "homeassistant" plain "%?"
           :if-new
           (file+head "homeassistant/%<%Y%m%d%H%M%S>-${slug}.org"
                      "#+title: ${title}\n#+filetags: :homeassistant:\n")
           :unnarrowed t)
          ("n"
           "novi" plain "%?"
           :if-new
           (file+head "novi/%<%Y%m%d%H%M%S>-${slug}.org"
                      "#+title: ${title}\n#+filetags: :novi:\n")
           :immediate-finish t
           :unnarrowed t)
          ("t"
           "tools" plain "* Background %?\n\n* Examples\n\n\n* References\n\n"
           :if-new
           (file+head "kali/%<%Y%m%d%H%M%S>-${slug}.org"
                      "#+title: ${title}\n#+filetags: :tools:\n")
           :immediate-finish t
           :unnarrowed t)))
  ;; ("t"
  ;;  "thesis" plain "%?"
  ;;  :if-new
  ;;  (file+head "thesis/%<%Y%m%d%H%M%S>-${slug}.org"
  ;;             "#+title: ${title}\n#+filetags: :thesis:\n")
  ;;  :immediate-finish nil
  ;;  :unnarrowed t)))
  ;; ("o"
  ;;  "OU Study Notes" plain "%?"
  ;;  :if-new
  ;;  (file+head "study/%<%Y%m%d%H%M%S>-${slug}.org"
  ;;             "#+title: ${title}\n#+filetags: :study:\n")
  ;;  :immediate-finish nil
  ;;  :unnarrowed t)))
  (require 'org-roam-protocol)
  (defun my/preview-fetcher ()
    (let* ((elem (org-element-context))
           (parent (org-element-property :parent elem)))
      ;; TODO: alt handling for non-paragraph elements
      (string-trim-right (buffer-substring-no-properties
                          (org-element-property :begin parent)
                          (org-element-property :end parent)))))

  (setq org-roam-preview-function #'my/preview-fetcher)
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry "* TODO %?"
           :target (file+head "%<%Y>/%<%Y-%m-%d>.org" "#+TITLE: %<%B %d, %Y>
#+filetags: dailies

- tags :: [[id:6b2b4539-b6c0-4966-ae41-ff9048be1e86][Daily Notes]]

* 📅 Dagelijkse vragen

** 🌙 Gisteravond heb ik...

** 🚀 Vandaag wil ik bereiken...

** 👏 Iets waar ik naar uit kijk...

** 👎 Hier worstel ik momenteel mee...

* Routine

- [ ] Plan de dag
- [ ] Werken aan mijn thesis
- [ ] De dag afsluiten, geen open taken

* Captured items

* Meta
# Local Variables:
# ispell-dictionary: \"nl_NL\"
# End:
")))))



;; (use-package! org-roam-review
;;   :commands (org-roam-review
;;              org-roam-review-list-by-maturity
;;              org-roam-review-list-recently-added)
;;   ;; Optional - tag all newly-created notes as seedlings
;;   :hook (org-roam-capture-new-node . org-roam-review-set-seedling)
;;   :general
;;   ;; Optional - bindings for evil-mode compatability.
;;   (:states '(normal) :keymaps 'org-roam-review-mode-map
;;    "TAB" 'magit-section-cycle
;;    "g r" 'org-roam-review-refresh)
;;   (:keymaps 'org-mode-map
;;    "C-c r r" '(org-roam-review-accept :wk "accept")
;;    "C-c r u" '(org-roam-review-bury :wk "bury")
;;    "C-c r x" '(org-roam-review-set-excluded :wk "set excluded")
;;    "C-c r b" '(org-roam-review-set-budding :wk "set budding")
;;    "C-c r s" '(org-roam-review-set-seedling :wk "set seedling")
;;    "C-c r e" '(org-roam-review-set-evergreen :wk "set evergreen")))

;; Ensure that you have languagetool 5.8 extracted in .doom.d
;; Ensure that you have languagetool 6.6 extracted in .doom.d
;;
;; wget https://languagetool.org/download/LanguageTool-5.8.zip
(use-package! langtool)

(after! langtool
  (setq langtool-language-tool-server-jar "/home/alex/.config/doom/LanguageTool-6.6/languagetool-server.jar"))
;; :bind (("\C-x4w" . langtool-check)
;;        ("\C-x4W" . langtool-check-done)
;;        ("\C-x4l" . langtool-switch-default-language)
;;        ("\C-x44" . langtool-show-message-at-point)
;;        ("\C-x4c" . langtool-correct-buffer))

;; (require 'find-lisp)


(after! org
  ;; (map! :map org-mode-map
  ;;       :localleader
  ;;       "L c" #'langtool-check
  ;;       "L d" #'langtool-check-done
  ;;       "L s" #'langtool-switch-default-language
  ;;       "L m" #'langtool-show-message-at-point
  ;;       "L x" #'langtool-correct-buffer)

  ;; TODO
  (setq! org-agenda-files)
  (setq org-agenda-start-day "0d") ; "0d" starts today
  (setq org-agenda-span 14)        ; Set the agenda to show the next 14 days


  ;; (append
  ;;   (find-lisp-find-files "/home/arjen/stack/Notebook/" ".org$")
  ;;   (find-lisp-find-files "/home/arjen/stack/roam-new/" ".org$"))


  ;;'("/home/alex/stack/roam-new/20231030133916-planning.org"
  ;;           "/home/alex/stack/roam-new/📥 Inbox.org"
  ;;  "/home/alex/stack/roam-new/20231030134027-tickler.org"


  org-refile-targets '((nil :maxlevel . 2)
                       ("/home/alex/stack/notes/roam/20231030133916-planning.org" :maxlevel . 4)
                       ("/home/alex/stack/notes/roam/20231030134027-tickler.org" :maxlevel . 2)))

;;(setq novi '("/home/alex/stack/roam-new/"))
(setq org-roam-completion-everywhere t)
(setq org-id-link-to-org-use-id t)
(setq org-image-actual-width 800)
(setq org-log-into-drawer t)

;; (add-load-path! (concat doom-user-dir "org-protocol-capture-html"))
;; (require 'org-protocol-capture-html)
(setq! org-capture-templates '(("b" "Blog idea" entry (file+olp "~/stack/Notebook/notes.org" "Personal" "Series")
                                "* %?\n%T" :prepend t)
                               ("t" "todo" entry
                                (file+headline "~/stack/Notebook/inbox.org" "Tasks")
                                "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")
                               ("T" "Tickler" entry
                                (file+headline "~/stack/Notebook/tickler.org" "Tickler")
                                "* %i%? \n %U")
                               ("w" "Web site" entry
                                (file "")
                                "* %a :website:\n\n%U %?\n\n%:initial")
                               ("wN" "Web link" entry
                                (file+headline ,(car org-agenda-files)
                                               "Links to read later")
                                "* TODO [#A]  %?%a \nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"Fri\"))\n"
                                :immediate-finish t :empty-lines 1)
                               ("e" "email" entry (file+headline "~/stack/Notebook/inbox.org" "Tasks from Email")
                                "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")))
;; Export code listings for LaTeX
(setq org-latex-listings t) ; Enable listings for Org's LaTeX export

;; Citar configuration for citation management
(after! citar
  (setq! reftex-default-bibliography '("/home/alex/stack/bib/bibliography.bib")
         bibtex-completion-bibliography '("/home/alex/stack/bib/bibliography.bib")
         citar-bibliography '("/home/alex/stack/bib/bibliography.bib")
         citar-file-note-org-include '(org-id org-roam-ref)
         citar-notes-paths '("~/stack/roam/papers")
         citar-library-paths '("~/stack/Zotero/pdf"))

  ;; Keybinding for inserting citations in `org-mode` and `latex-mode`
  (map! :map latex-mode-map
        :localleader
        "n i" #'citar-insert-citation)
  (map! :map org-mode-map
        :localleader
        "n i" #'citar-insert-citation)

  ;; (use-package! citar
  ;;   :config
  ;;   (setq org-cite-export-processors
  ;;         '((latex . natbib) ;; Use natbib for LaTeX export
  ;;           (t . csl)))      ;; Default export processor for non-LaTeX formats

  ;;   (setq org-cite-natbib-options
  ;;         '(:style "authoryear" :command "citep")) ; Use `citep` for inline citations in natbib

  ;; If you need citar-org-roam integration
  (use-package! citar-org-roam
    :config
    (setq citar-org-roam-capture-template-key "p")
    ;; Uncomment and customize note title if necessary
    ;; (setq citar-org-roam-note-title-template "${author} - ${title}\n#+filetags: ${tags}")
    (citar-org-roam-mode)))

(after! org
  ;; Optional: Enable modern Org styling features
  ;; (setq org-modern-block-fringe 2) ; Customize block fringe margin
  (setq org-modern-table nil) ; Disable modern table styling if unnecessary
  (setq org-modern-timestamp nil) ; Disable modern timestamp features if unnecessary
  (global-org-modern-mode) ; Enable Org Modern globally

  ;; Activate `ox-extra` for advanced export options (like ignoring headlines)
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines))

  ;; Add a custom LaTeX class "chapterbook" for Org export
  (add-to-list 'org-latex-classes
               '("chapterbook"
                 "\\documentclass{book}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")))

  ;; Set the default LaTeX class to "chapterbook"
  (setq org-latex-default-class "chapterbook"))

(after! cider
  (setq cljr-warn-on-eval nil))


;; Add word count to mode-line, only useful for modes like org and markdown
;; for writing papers and articles
(setq doom-modeline-enable-word-count t)



(defun aw/cleanup-lsp ()
  "Remove all the workspace folders from LSP"
  (interactive)
  (let ((folders (lsp-session-folders (lsp-session))))
    (while folders
      (lsp-workspace-folders-remove (car folders))
      (setq folders (cdr folders)))))



(with-eval-after-load 'org-capture
  (setq denote-org-capture-specifiers "%l\n%i\n%?")
  (add-to-list 'org-capture-templates
               '("n" "New note (with denote.el)" plain
                 (file denote-last-path)
                 #'denote-org-capture
                 :no-save t
                 :immediate-finish nil
                 :kill-buffer t
                 :jump-to-captured t)))


(use-package! citar-org-roam
  :config
  (setq citar-org-roam-capture-template-key "p")
  ;;(setq citar-org-roam-note-title-template "${author} - ${title}\n#+filetags: ${tags}")
  (citar-org-roam-mode))


(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration
               '(".*\\.rsc$" . "rascal"))

  (setq lsp-semantic-tokens-enable t)
  (defun lsp-rascal-tcp-connect-to-port ()
    (list
     :connect (lambda (filter sentinel name _environment-fn)
                (let* ((host "localhost")
                       (port 8888)
                       (tcp-proc (lsp--open-network-stream host port (concat name "::tcp"))))

                  (set-process-query-on-exit-flag tcp-proc nil)
                  (set-process-filter tcp-proc filter)
                  (set-process-sentinel tcp-proc sentinel)
                  (cons tcp-proc tcp-proc)))
     :test? (lambda () t)))

  (lsp-register-client
   (make-lsp-client :new-connection (lsp-rascal-tcp-connect-to-port)
                    :major-modes '(rascal-mode)
                    :server-id 'rascal-lsp)))

(add-to-list 'auto-mode-alist '("\\.rsc$" . rascal-mode))

(require 'all-the-icons)
(customize-set-value
 'org-agenda-category-icon-alist
 `(
   ("inbox" ,(list (all-the-icons-faicon "inbox")) nil nil :ascent center)
   ("gcal-novi" ,(list (all-the-icons-faicon "building-o")) nil nil :ascent center)
   ("gcal-gezin" ,(list (all-the-icons-faicon "users")) nil nil :ascent center)
   ("gcal-ou" ,(list (all-the-icons-faicon "university")) nil nil :ascent center)
   ("daily" ,(list (all-the-icons-faicon "circle-o-notch")) nil nil :ascent center)
   ("work" ,(list (all-the-icons-faicon "cogs")) nil nil :ascent center)
   ("habit" ,(list (all-the-icons-faicon "circle-o-notch")) nil nil :ascent center)
   ("study" ,(list (all-the-icons-faicon "university")) nil nil :ascent center)
   ("notes" ,(list (all-the-icons-faicon "clipboard")) nil nil :ascent center)))


(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-super-agenda-groups '((:name "My Date with Destiny (and Coffee)"
                                   :time-grid t
                                   :scheduled today)
                                  (:name "Due Today"
                                   :scheduled today)
                                  (:name "Important"
                                   :priority "A")
                                  (:name "Overdue"
                                   :deadline past)
                                  (:name "Overdue scheduled"
                                   :scheduled past)
                                  (:name "Due soon"
                                   :deadline future)
                                  (:priority<= "B"
                                   :order 1)))
  (setq  org-deadline-warning-days 7
         org-agenda-breadcrumbs-separator " ❱ ")

  :config
  (org-super-agenda-mode))

(after! org
  (use-package! org-drill)
  ;; https://www.reddit.com/r/emacs/comments/hnf3cw/my_orgmode_agenda_much_better_now_with_category/
  (setq org-agenda-custom-commands
        '(
          ("x" "My Agenda"
           (
            (agenda "" (
                        ;; https://emacs.stackexchange.com/questions/38742/implement-scheduling-as-suggested-in-deep-work-using-emacs-org-mode
                        (org-agenda-sorting-strategy '((agenda habit-down time-up ts-up
                                                        priority-down category-keep)
                                                       (todo priority-down category-keep)
                                                       (tags priority-down category-keep)
                                                       (search category-keep)))

                        (org-agenda-skip-scheduled-if-done nil)
                        (org-agenda-time-leading-zero t)
                        (org-agenda-timegrid-use-ampm nil)
                        (org-agenda-skip-timestamp-if-done t)
                        (org-agenda-skip-deadline-if-done t)
                        (org-agenda-start-day "+0d")
                        (org-agenda-span 5)
                        (org-agenda-overriding-header "⚡ Calendar")
                        (org-agenda-repeating-timestamp-show-all nil)
                        (org-agenda-remove-tags t)
                        (org-agenda-prefix-format "   %i %?-2 t%s")
                        ;; (org-agenda-prefix-format "  %-3i  %-15b%t %s")
                        ;; (concat "  %-3i  %-15b %t%s" org-agenda-hidden-separator))
                        ;; (org-agenda-todo-keyword-format " ☐ ")
                        ;; (org-agenda-todo-keyword-format "%-12s")
                        (org-agenda-todo-keyword-format "")
                        (org-agenda-time)
                        (org-agenda-current-time-string "ᐊ┈┈┈┈┈┈┈ Now")
                        (org-agenda-scheduled-leaders '("" ""))
                        (org-agenda-deadline-leaders '("Deadline:  " "In %3d d.: " "%2d d. ago: "))
                        (org-agenda-time-grid (quote ((today require-timed remove-match) () "      " "┈┈┈┈┈┈┈┈┈┈┈┈┈")))))

            (tags "+TODO=\"TODO\"" (
                                    (org-agenda-overriding-header "\n⚡ To Do")
                                    (org-agenda-sorting-strategy '(priority-down))
                                    (org-agenda-remove-tags t)
                                    ;; (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp))
                                    (org-agenda-todo-ignore-scheduled 'all)
                                    (org-agenda-prefix-format "   %-2i %?b")
                                    (org-agenda-todo-keyword-format "")))

            (tags "+TODO=\"NEXT\"" (
                                    (org-agenda-overriding-header "\n⚡ Next")
                                    (org-agenda-sorting-strategy '(priority-down))
                                    (org-agenda-remove-tags t)
                                    (org-agenda-todo-ignore-scheduled 'all)
                                    (org-agenda-prefix-format "   %-2i %?b")
                                    (org-agenda-todo-keyword-format ""))))))))


(use-package! org-roam-dblocks)

(after! org
  (defun my/org-tags-view (&optional todo-only watch)
    (let ((org-use-tag-inheritance nil))
      (org-tags-view todo-only watch)))

  (advice-add 'org-tags-view :around
              (lambda (orig-fun &rest args)
                (let ((org-use-tag-inheritance nil))
                  (apply orig-fun args)))))

(use-package! ox-hugo)

(setq openai-key (getenv "OPENAI_API_KEY"))

(use-package! company-org-block
  :custom
  (company-org-block-edit-style 'auto) ;; 'auto, 'prompt, or 'inline
  :hook ((org-mode . (lambda ()
                       (setq-local company-backends '(company-org-block))
                       (company-mode +1)))))

(setq chatgpt-shell-openai-key (getenv "OPENAI_API_KEY"))

(use-package! lsp-ltex
  :after lsp
  ;; :hook (text-mode . (lambda ()
  ;;                      (require 'lsp-ltex)
  ;;                      (lsp)))  ; or lsp-deferred
  :init
  (setq lsp-ltex-version "15.2.0")
  (setq lsp-ltex-check-frequency "save")

  :config

  (setq lsp-ltex-check-frequency "save")
  (add-to-list 'lsp-language-id-configuration
               '(mu4e-compose-mode . "org"))
  (add-to-list 'lsp-language-id-configuration
               '(org-msg-edit-mode . "org")))


(use-package! org-ref)

;; (use-package! base16-theme)

(after! org
  ;;  (setq org-modern-block-fringe 2)
  (setq org-modern-table nil)
  (setq org-modern-timestamp nil)
  (global-org-modern-mode)
  ;; Ignore optie voor header exports
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines)))

;; Non-wrapping tables
(defun my/toggle-olivetti-and-line-wrap-for-org-table ()
  "Toggle olivetti-mode and line wrap when inside an Org table."
  (when
      (derived-mode-p 'org-mode)
    (if
        (org-at-table-p)
        (progn
          (setq-local truncate-lines t))
      (progn
        (setq-local truncate-lines nil)))))

(add-hook 'post-command-hook #'my/toggle-olivetti-and-line-wrap-for-org-table)
(set-fontset-font t 'symbol "Noto Color Emoji" nil 'append)

(custom-set-variables '(emojify-display-style 'unicode))


(after! chatgpt-shell
  (defun chatgpt-shell-academic-region (prefix)
    "Proofread and update the text to academic standards.

With PREFIX, invert `chatgpt-shell-insert-queries-inline' choice."
    (interactive "P")
    (chatgpt-shell-send-region-with-header
     (concat
      "As an English spelling corrector and improver, your task is to improve the structure of a provided paragraph while also correcting any spelling errors. You should should make the text fit for academics, without changing the meaning.

Your response should only include corrections and improvements to the original text. Please do not provide explanations or additional commentary. Your goal is to create a more literary version of the paragraph that maintains its original meaning but presents it in a more sophisticated manner.

Here is the text:" prefix)))

  (map! :map text-mode-map
        :localleader
        "j a" #'chatgpt-shell-academic-region)


  (map! :map TeX-mode-map
        :localleader
        "j a" #'chatgpt-shell-academic-region))

;; (setq ispell-program-name "hunspell")
;; (setq ipsell-dictionary "nl_NL, en_EN")
(setq ispell-program-name "hunspell")
(setq ispell-dictionary "en_US")
;; (use-package! lsp-tailwindcss)

(use-package! delve
  :after org-roam

  :config
  (setq delve-storage-paths "~/stack/org/"))

;; NixOS / nix use of Java together with Emacs
;;https://dschrempf.github.io/emacs/2023-03-02-emacs-java-and-nix/
(after! lsp-java
  (defun lsp-java--ls-command ()
    (list "jdt-language-server"
          "-configuration" "../config-linux"          "-data" "../java-workspace")))

(after! cc-mode
  (defun my-set-lsp-path ()
    (setq lsp-java-server-install-dir (getenv "JDTLS_PATH")))
  (add-hook 'java-mode-hook #'my-set-lsp-path))

;; When the font patches are part of the Doom distribution then
;; this code becomes obsolete
;; https://github.com/doomemacs/doomemacs/issues/7036
(defun add-back-emoji-fallback-font-families ()
  (when (fboundp 'set-fontset-font)
    (let ((fn (doom-rpartial #'member (font-family-list))))
      (when-let (font (cl-find-if fn doom-emoji-fallback-font-families))
        (set-fontset-font t 'unicode font nil 'append)))))

(add-hook 'after-setting-font-hook 'add-back-emoji-fallback-font-families)
(add-to-list 'doom-symbol-fallback-font-families "Symbols Nerd Font")
;; end future obsolete code
;; ;; in packages.el
;; (package! shell-maker
;;   :recipe (:type git :host github :repo "xenodium/chatgpt-shell"))
;; (package! chatgpt-shell
;;   :recipe (:type git :host github :repo "xenodium/chatgpt-shell"))

;; in config.el
;; chatgpt-shell
(setq chatgpt-shell-openai-key
      (with-temp-buffer
        (insert-file-contents "/home/alex/.config/openai/key")
        (string-trim (buffer-string))))
(setq dall-e-shell-openai-key
      (with-temp-buffer
        (insert-file-contents "/home/alex/.config/openai/key")
        (string-trim (buffer-string))))
(setq chatgpt-model "gpt-4o")
;; dall-e-shell
(setq dall-e-shell-model-version "dall-e-3")
(setq dall-e-shell-image-output-directory "/home/alex/Media/AI/Emacs/")
(setq dall-e-shell-image-quality "hd")

(defcustom chatgpt-shell-prompt-header-proofread-region-dutch
  "Help mij met het proeflezen van de volgende Nederlandse tekst, vermeld daarbij ook de aanpassingen die zijn gedaan:"
  "Prompt header for `chatgpt-shell-prompt-redigeer-selectie`."
  :type 'string
  :group 'chatgpt-shell)

(defun chatgpt-shell-prompt-redigeer-selectie ()
  "Proofread Dutch from region using ChatGPT."
  (interactive)
  (chatgpt-shell-send-region-with-header chatgpt-shell-prompt-header-proofread-region-dutch))
