;;	Jeff Mickey's .emacs.d/init.el file
;;
;;	the awkward part is that I wrote this in vim :/

;; time our .emacs loading
(defvar *emacs-load-start* (current-time))

;; Get rid of things.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq warning-suppress-types nil)
;; Operating system hacks
(when (eq system-type 'darwin)
  (let ((mac-paths '("/Users/codemac/bin"
		     "/Users/codemac/.cabal/bin"
		     "/usr/local/bin"
		     "/usr/local/sbin"
		     "/usr/bin"
		     "/usr/sbin"
		     "/bin"
		     "/sbin")))
    (setenv "PATH" (concat (getenv "PATH") ":"
			   (mapconcat 'identity mac-paths ":")))
    (setq exec-path (append exec-path mac-paths))))

;; add my site-lisp dir as a place to load things
(add-to-list 'load-path "~/.emacs.d/site-lisp")
(add-to-list 'load-path "~/.emacs.d/pkg-init")

(defun dirs-inside-directory (parent)
  (let (foo)
    (dolist (file (directory-files parent t))
      (when (and (not (member (file-name-nondirectory file)
                              '("." "..")))
                 (file-directory-p file))
        (setq foo (cons file foo))))
    foo))

;; Automagically load all folders in site-lisp as well! Thank you benny!
(mapc (lambda (x) (add-to-list 'load-path x))
		(dirs-inside-directory "~/.emacs.d/site-lisp/"))


;; fonts yay
;(add-to-list 'default-frame-alist '(font . "-xos4-terminus-medium-r-normal--12-120-72-72-c-60-iso8859-1"))
;(add-to-list 'default-frame-alist '(font . "-xos4-terminus-medium-r-normal--14-140-72-72-c-80-iso8859-1"))
;(add-to-list 'default-frame-alist '(font . "smoothansi"))
;(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-9"))
(add-to-list 'default-frame-alist '(font . "Dina-11"))
;(add-to-list 'default-frame-alist '(font . "Consolas-13"))

;;	Get rid of the annoying bell
(setq visible-bell 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; lines!
;;
(line-number-mode 1)
(column-number-mode 1)

;; Turn on the clock!
(autoload 'display-time "time" "clock in status bar" t) ;shut up compiler
(if (locate-library "time")
    (progn
      (require 'time)
      (defconst display-time-day-and-date t)
      (defconst display-time-24hr-format t)
      (display-time))
    (message "Get time.el from your distro."))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; backup files

;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(defvar autosave-dir
 (concat "/tmp/emacs_autosaves/" (user-login-name) "/"))

(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
   (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
    (expand-file-name
     (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (concat "/tmp/emacs_backups/" (user-login-name) "/"))
(setq backup-directory-alist (list (cons "." backup-dir)))
;; http://snarfed.org/space/gnu%20emacs%20backup%20files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; yes or no
;;; stfu and take my freaking answer

(fset 'yes-or-no-p 'y-or-n-p)

;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; some global keys!
;;
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)

(global-set-key [f5] 'bookmark-bmenu-list)
(global-set-key [f6] 'bookmark-set)
(global-set-key [f7] 'bookmark-jump)
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; occur in isearch!
;; taken from http://www.emacswiki.org/emacs/OccurFromIsearch
(defun isearch-occur ()
      "Invoke `occur' from within isearch."
      (interactive)
      (let ((case-fold-search isearch-case-fold-search))
        (occur (if isearch-regexp isearch-string (regexp-quote isearch-string)))))

(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ediff
;;
(setq ediff-split-window-function (lambda (&optional arg)
                                        (if (> (frame-width) 150)
                                            (split-window-horizontally arg)
                                          (split-window-vertically arg))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; private settings
;; Here I list my "private" varables so you know what
;; things are.

;; irc
(defvar cm-freenode-pass "nope"
  "The nickserv password for freenode.")
(defvar cm-oftc-pass "nope"
  "The nickserv password for oftc.")
(defvar cm-what-pass "nope"
  "The nickserv password for what.")
(defvar cm-rizon-pass "nope"
  "The nickserv password for rizon.")
(defvar cm-bitlbee-pass "nope"
  "The password for bitlbee!")
(defvar cm-irc-channel-alist
  '(("freenode" "#archlinux" "#emacs")
    ("oftc" "#ikiwiki"))
  "The channel list..")

(load-file "~/.emacs-priv.el")
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; printing!
;; This requires xpp
;(require 'lpr)
(setq lpr-command "gtklp")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; sticky buffer
;;; http://www.reddit.com/r/emacs/comments/gjqki/is_there_any_way_to_tell_emacs_to_not/c1o26uk

(defun toggle-sticky-buffer-window ()
  "Toggle whether this window is dedicated to this buffer."
  (interactive)
  (set-window-dedicated-p
   (selected-window)
   (not (window-dedicated-p (selected-window))))
  (if (window-dedicated-p (selected-window))
      (message "Window is now dedicated.")
    (message "Window is no longer dedicated.")))

(global-set-key [(super d)] 'toggle-sticky-buffer-window)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; revert buffer
;;;

(defun cm-revert-buffer ()
    "save the current position to tmp, revert buffer, go back to tmp"
    (interactive)
    (let ((tmp (point))
	  )
	(revert-buffer t)
	(goto-char tmp)))

(global-set-key [f8] 'cm-revert-buffer)

;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; hippie
;(global-set-key (kbd "TAB") 'hippie-expand)
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; server
;;;
(unless (string-equal "root" (getenv "USER"))
;; Only start server mode if it isn't started already
  (when (or (not (boundp 'server-process))
  (not (eq (process-status server-process)
  'listen)))
  (server-start)))
;;

;;; MY REQUIREMENTS!
(require 'cm-cl)
;(require 'cm-package)
(require 'cm-markdown)
(require 'cm-wikipedia)
(require 'cm-ido)
(require 'cm-identica)
;(require 'cm-ecb)
(require 'cm-haskell)
(require 'cm-egg)
(require 'cm-anything)
(require 'cm-bbdb)
(require 'cm-mode-compile)
(require 'cm-gnuplot)
(require 'cm-muse)
(require 'cm-ruby)
(require 'cm-yaml)
(require 'cm-haml)
;(require cm-emms)
(require 'cm-journal)
(require 'cm-org)
(require 'cm-w3m)
(require 'cm-rcirc)
;(require 'cm-command-frequency) ; not using this anymore...
(require 'cm-blog)
(require 'cm-erc)
(require 'cm-wanderlust)
(require 'cm-jabber)
(require 'cm-c)
(require 'cm-tramp)
(require 'cm-uniquify)
(require 'cm-tabbar)
(require 'cm-xcscope)
;(require 'cm-ascope)
(require 'cm-yasnippet)
(require 'cm-gnus)
(require 'cm-dired)
(require 'cm-word-count)
(require 'cm-ibuffer)
(require 'cm-minimap)
(require 'cm-android)
(require 'cm-smart-tab)
(require 'cm-eshell)

;; things that I don't want on the mac
(unless (eq system-type 'darwin)
  (require 'cm-ecb)
  (require 'cm-netapp)
  (require 'cm-emms))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CUSTOM!
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(android-mode-avd "TodoDevice")
 '(auto-image-file-mode t)
 '(browse-url-firefox-new-window-is-tab t)
 '(browse-url-firefox-program "firefox")
 '(ecb-options-version "2.40")
 '(jabber-account-list (quote (("j@xmpp.us") ("codemac@gmail.com" (:network-server . "talk.google.com") (:port . 5222)))))
 '(jabber-roster-line-format " %c %-25n %u %-8s  %S")
 '(org-agenda-files (quote ("~/org/fitness.org" "~/org/gtd.org" "~/org/inbox.org" "~/org/netapp.org")))
 '(org-remember-templates (quote (("Todo" 116 "* TODO %?
  %i
  %a" "~/org/inbox.org" "Inbox" nil) ("Future Todo" 102 "* TODO %?
  %i
  %^T
  %a" "~/org/inbox.org" "Inbox" nil) ("Scheduled Todo" 115 "* TODO %?
  %i
  SCHEDULED: %^T
  %a" nil nil nil) ("Music" 109 "* TODO %?
  %U" "~/org/music.org" "To Get" nil) ("Journal" 106 "* %U %?

  %i
  %a" "~/org/notes.org" nil nil) ("Idea" 105 "* %^{Title}
  %i
  %a" "~/org/notes.org" "New Ideas" nil))))
 '(w3m-use-cookies t))

;; COLORS PLZ
(require 'color-theme)
(load-library "color-theme-colorful-obsolescence")
;(load-library "manoj-colors")
(load-library "zenburn")
(defun set-up-colors()
  (interactive)
  (setq color-theme-is-global t)
  (setq color-theme-load-all-themes nil)
  (color-theme-initialize)
;  (color-theme-colorful-obsolescence)
	(color-theme-zenburn)
;    (color-theme-rlx)
  )
(set-up-colors)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; last line?
(message "My .emacs loaded in %ds" (destructuring-bind (hi lo ms) (current-time)
                             (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))
