(defpackage #:nantango/views/root
  (:use #:cl
        #:lsx
        #:utopian)
  (:export #:index-page))
(in-package #:nantango/views/root)

(named-readtables:in-readtable :lsx-syntax)

(defview index-page ()
  ()
  (:render
   <html>
     <head>
       <title>Nantango</title>
     </head>
     <body>
       <h1>Nantango</h1>
       <div>The List of Words
         <ul>
         {(mapcar (lambda (level)
                    <li>
                      <p><a href={(format nil "/show-level/~A" level)}>Level {level}</a></p>
                    </li>)
                  '(1 2 3 4 5 6 7 8 9 10 11 12))}
         </ul>
       </div>
       <div>Play Quiz
          <p><a href="/play-quiz">Go to Quiz Page</a></p>
       </div>

       <p><img src="/assets/example.jpg" style="width:100px"/></p>
     </body>
   </html>))
