(defpackage #:nantango/models/quiz
  (:use #:cl
        #:mito)
  (:export #:quiz
           #:quiz-id
           #:quiz-level
           #:quiz-english
           #:quiz-sound
           #:quiz-ja
           #:quiz-ja2
           ))
(in-package #:nantango/models/quiz)

(deftable quiz()
  ((level :col-type (or :integer :null))
   (id :col-type (or :text :null))
   (english :col-type (or :text :null))
   (sound :col-type (or :text :null))
   (ja :col-type (or :text :null))
   (ja2 :col-type (or :text :null))))

;; same as above
;;(defclass quiz ()
;;  ((level :col-type (or :integer :null)
;;          :accessor quiz-level)
;;   (english :col-type (or :text :null)
;;            :accessor quiz-english)
;;   (sound :col-type (or :text :null)
;;          :accessor quiz-sound)
;;   (ja :col-type (or :text :null)
;;       :accessor quiz-ja)
;;   (ja2 :col-type (or :text :null)
;;        :accessor quiz-ja2)  )
;;   (:metaclass mito:dao-table-class))
