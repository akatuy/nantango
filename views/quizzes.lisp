(defpackage #:nantango/views/quizzes
  (:use #:cl
        #:lsx
        #:nantango/models/quiz
        #:utopian)
  (:export #:listing-page
           #:show-page
           #:show-level-page
           #:play-quiz-page
           ))
(in-package #:nantango/views/quizzes)

(named-readtables:in-readtable :lsx-syntax)

(defview listing-page ()
  (quizzes)
  (:render
   <html>
     <head>
       <title>quizzes - nantango</title>
     </head>
     <body>
       <h1>quizzes</h1>
       <ol>
         {(mapcar (lambda (quiz)
                    <li>
                      <a href={(format nil "/quizzes/~A" (mito:object-id quiz))}>
                        {(quiz-english quiz)} : {(quiz-ja quiz)}
                      </a>
                    </li>)
                  quizzes)}
       </ol>
     </body>
   </html>))

(defview show-level-page ()
  (selected-words)
  (:render
   <html>
     <head>
       <title>words</title>
     </head>
     <body>
       <ol>
         {(mapcar (lambda (selected-word)
                    <li>
                      <a style="text-decoration: none;color:black;" href={(format nil "/quizzes/~A" (mito:object-id selected-word))}>
                        {(quiz-english selected-word)} : {(quiz-ja selected-word)} （{(quiz-sound selected-word)}）
                      </a>
                    </li>)
                  selected-words)}
       </ol>
     </body>
   </html>))

(defview show-page ()
  (quiz)
  (:render
   <html>
     <head>
       <title>
         {(quiz-english quiz)} - nantango
       </title>
     </head>
     <body>
       <h1>Level: {(quiz-level quiz)}</h1>   
       <h1>{(quiz-english quiz)}</h1>
       <h1>{(quiz-sound quiz)}</h1>
       <h1>{(quiz-ja quiz)}</h1>
       <h1>{(quiz-ja2 quiz)}</h1>
     </body>
   </html>))


(defview play-quiz-page ()
  ()
  (:render #P"index.html"))

