(defpackage #:nantango/controllers/root
  (:use #:cl
        #:utopian
        #:nantango/views/root)
  (:export #:index))
(in-package #:nantango/controllers/root)

(defun index (params)
  (declare (ignore params))
  (render 'index-page))
