(defpackage #:nantango/config/routes
  (:use #:cl
        #:utopian)
  (:export #:*routes*))
(in-package #:nantango/config/routes)

(defroutes *routes* ()
  (:controllers #P"../controllers/"))

(route :GET "/" "root:index")
(route :GET "/quizzes" "quizzes:listing")
(route :GET "/quizzes/:id" "quizzes:show")

(route :GET "/show-level/:level" "quizzes:show-level")

(route :GET "/play-quiz" "quizzes:play-quiz")

