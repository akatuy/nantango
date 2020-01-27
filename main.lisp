(defpackage #:nantango
  (:nicknames #:nantango/main)
  (:use #:cl)
  (:import-from #:nantango/config/application)
  (:import-from #:nantango/config/routes)
  (:export #:connect-db))
(in-package #:nantango)

(defun connect-db ()
  (let ((utopian/config:*config-dir*
          (probe-file (asdf:system-relative-pathname :nantango "config/environments/"))))
    (apply #'mito:connect-toplevel (utopian/config:db-settings))))

(connect-db)