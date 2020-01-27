(defpackage #:nantango/config/environments/local
  (:use #:cl))
(in-package #:nantango/config/environments/local)

;`(:databases
;  ((:maindb . (:postgres
;    :database-name "nantango" :username "teacher" :password "teacher2020"))))

`(:databases
  ((:maindb . (:sqlite3
               :database-name ,(asdf:system-relative-pathname :nantango #P"db/data.db")))))