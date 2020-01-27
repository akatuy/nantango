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
    (:render
     <html>
     <head>
        <title>なんたんご</title>
        <link rel="stylesheet" type="text/css" href="/assets/quiz-front/css/style.css" />
     </head>
     <body>
        <div id="container">
           <div id="start">なんたんご</div>

           <div class="level" id="btn_level1">Lv1</div>
           <div class="level" id="btn_level2">Lv2</div>
           <div class="level" id="btn_level3">Lv3</div>
           <div class="level" id="btn_level4">Lv4</div>
           <div class="level" id="btn_level5">Lv5</div>
           <div class="level" id="btn_level6">Lv6</div>
           <div class="clear"></div>
           <div class="level" id="btn_level7">Lv7</div>
           <div class="level" id="btn_level8">Lv8</div>
           <div class="level" id="btn_level9">Lv9</div>
           <div class="level" id="btn_level10">Lv10</div>
           <div class="level" id="btn_level11">Lv11</div>
           <div class="level" id="btn_level12">Lv12</div>

           <div id="quiz" style="display: none">
              <div id="question"></div>
              <div id="choices" ontouchstart="">
                 <div class="choice" id="A"></div>
                 <div class="choice" id="B"></div>
                 <div class="choice" id="C"></div>
              </div>
              <div id="timer">
                <div id="counter"></div>
              </div>
              <div id="progress"></div>
              <div id="qImg"></div>
           </div>

          <button type="button" id="btn1" class="button" onclick="alert('Not implemented yet: \n\nIt will send the result to Utopian.')" style="display: none">Save the Result</button>
          <button type="button" id="btn2" class="button" onclick="location.reload();" style="display: none">Back to Top</button>
          </div>
          <br/>
          <div id="namae"></div>
          <div id="review"></div>
          <script src="/assets/quiz-front/js/talkify.min.js"></script>
          <script src="/assets/quiz-front/data/dict.js"></script>
          <script src="/assets/quiz-front/js/quiz.js"></script>
      </body>
      </html>))


