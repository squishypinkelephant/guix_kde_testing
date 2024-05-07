;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2020 Alex Griffin <a@ajgrf.com>

(define-module (kde-testing modules)
  #:use-module (ice-9 match)
  #:export (import-kde-testing-module?))

(define (kde-testing-module-name? name)
  "Return true if NAME (a list of symbols) denotes a Guix or kde-testing module."
  (match name
    (('guix _ ...) #t)
    (('gnu _ ...) #t)
    (('kde-testing _ ...) #t)
    (_ #f)))

;; Since we don't use deduplication support in 'populate-store', don't
;; import (guix store deduplication) and its dependencies, which
;; includes Guile-Gcrypt.
(define (import-kde-testing-module? module)
  "Return true if MODULE is not (guix store deduplication)"
  (and (kde-testing-module-name? module)
       (not (equal? module '(guix store deduplication)))))
