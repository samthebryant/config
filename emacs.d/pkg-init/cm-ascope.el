(require 'ascope)

;; The following line corresponds to be beginning of the "Cscope" menu.
(define-key cscope:map "\C-css" 'ascope-find-this-symbol)
(define-key cscope:map "\C-csg" 'ascope-find-global-definition)
;(define-key cscope:map "\C-csG" 'cscope-find-global-definition-no-prompting)
(define-key cscope:map "\C-csc" 'ascope-find-functions-calling-this-function)
(define-key cscope:map "\C-csC" 'ascope-find-called-functions)
(define-key cscope:map "\C-cst" 'ascope-find-this-text-string)
;(define-key cscope:map "\C-cse" 'cscope-find-egrep-pattern)
;(define-key cscope:map "\C-csf" 'cscope-find-this-file)
(define-key cscope:map "\C-csi" 'ascope-find-files-including-file)
(define-key cscope:map "\C-csa" 'ascope-all-symbol-assignments)
;; --- (The '---' indicates that this line corresponds to a menu separator.)
;(define-key cscope:map "\C-csb" 'cscope-display-buffer)
;(define-key cscope:map "\C-csB" 'cscope-display-buffer-toggle)
;(define-key cscope:map "\C-csn" 'cscope-next-symbol)
;(define-key cscope:map "\C-csN" 'cscope-next-file)
;(define-key cscope:map "\C-csp" 'cscope-prev-symbol)
;(define-key cscope:map "\C-csP" 'cscope-prev-file)
;(define-key cscope:map "\C-csu" 'cscope-pop-mark)
;; ---
;(define-key cscope:map "\C-csa" 'cscope-set-initial-directory)
;(define-key cscope:map "\C-csA" 'cscope-unset-initial-directory)
;; ---
;(define-key cscope:map "\C-csL" 'cscope-create-list-of-files-to-index)
;(define-key cscope:map "\C-csI" 'cscope-index-files)
;(define-key cscope:map "\C-csE" 'cscope-edit-list-of-files-to-index)
;(define-key cscope:map "\C-csW" 'cscope-tell-user-about-directory)
;(define-key cscope:map "\C-csS" 'cscope-tell-user-about-directory)
;(define-key cscope:map "\C-csT" 'cscope-tell-user-about-directory)
;(define-key cscope:map "\C-csD" 'cscope-dired-directory))
(provide 'cm-ascope)