(defpackage #:nantango/config/application
  (:use #:cl
        #:utopian)
  (:import-from #:lack.component
                #:to-app
                #:call)
  (:import-from #:lack
                #:builder)
  (:import-from #:cl-ppcre)
  (:export #:nantango-app))
(in-package #:nantango/config/application)

(defapp nantango-app ()
  ()
  (:config #P"environments/"))

(defmethod to-app ((app nantango-app))
  (builder
   (:static
    :path (lambda (path)
            (if (ppcre:scan "^(?:/assets/|/robot\\.txt$|/favicon\\.ico$)" path)
                path
                nil))
    :root (asdf:system-relative-pathname :nantango #P"public/"))
   :accesslog
   (:mito (db-settings :maindb))
   :session
   (call-next-method)))
