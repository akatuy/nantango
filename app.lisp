(defpackage #:nantango/app
  (:use #:cl
        #:nantango/config/routes
        #:nantango/config/application))
(in-package #:nantango/app)

(make-instance 'nantango-app
               :routes *routes*
               :models #P"models/")
