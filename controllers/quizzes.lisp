(defpackage #:nantango/controllers/quizzes
  (:use #:cl
        #:utopian
        #:nantango/views/quizzes
        #:nantango/models/quiz)
  (:import-from #:assoc-utils
                #:aget)
  (:export #:listing
           #:show
           #:show-level
           #:play-quiz           
           #:get-quiz-english
           ))
(in-package #:nantango/controllers/quizzes) 

(defun get-quiz-english(id)
  (nantango/models/quiz:quiz-sound 
    (mito:find-dao 'nantango/models/quiz:quiz :id (write-to-string id))))

(defun listing (params)
  (declare (ignore params))
  (render 'listing-page
          :quizzes (mito:select-dao 'nantango/models/quiz:quiz)))

(defun show (params)
  (let ((quiz (mito:find-dao 'nantango/models/quiz:quiz :id (aget params :id))))
    (unless quiz
      (throw-code 404))
    (render 'show-page :quiz quiz))) 
    ; render 'テンプレ名 :シンボル名前 シンボル

(defun show-level (params)
  (render 'show-level-page
          :selected-words (mito:select-dao 'nantango/models/quiz:quiz
                            (sxql:where (:= :level (aget params :level))))))

(defun play-quiz (params)
  (declare (ignore params))
  (uiop:read-file-string
    (asdf:system-relative-pathname 
    :nantango #P"public/assets/quiz-front/index.html")))

(defvar *quizzes*
  ;; クイズ一覧を作成する
  (loop for line in
           (uiop:read-file-lines
            (merge-pathnames
             "db/data.csv"
             (asdf:system-source-directory "nantango")))
        unless (eql (aref line 0) #\#)
        collect (uiop:split-string line :separator '(#\,))))

;; 状態
(defparameter *current-quizzes* '())
(defparameter *current-quiz* '())
(defparameter *current-quiz-no* 0)
(defparameter *current-options* '())
(defparameter *current-words* '())
(defparameter *current-quizzes-en* '())
(defparameter *current-quizzes-length* 0)
(defparameter *current-level* 1)
(defparameter *wrong-quizzes* '())
(defparameter *quiz-numbers* '())

;; 補助関数
(defun shuffle (sequence)
  ;; シーケンスをシャッフルする
  (loop for i from (length sequence) downto 2
        do (rotatef (elt sequence (random i))
                    (elt sequence (1- i))))
  sequence)

(defparameter *level-border*
  ;; クイズレベルの境界線を定義する
  '((1 1 1053)(2 1054 2054)(3 2055 3050)
    (4 3051 4044)(5 4045 5040)(6 5041 6020)
    (7 6021 7006)(8 7007 7991)(9 7992 8969)
    (10 8970 9947)(11 9948 10930)(12 10931 11904)))

(defun make-level-quizzes(level)
  (labels((get-level-start(level)
            (second (assoc level *level-border*)))
          (get-level-end(level)
            (third (assoc level *level-border*))))
    ;; クイズ問題セットを設定する
    (let((start (get-level-start level))
         (end (- (get-level-end level) 1)))
      (setf *current-words*
            (loop
              for quiz-number
              from start to end
              collect (nth quiz-number *quizzes*)))
      (setf *current-quizzes-length*
            (length *current-words*)))))

(defun make-3-uniques(n)
  ;; 重複のない3つの数字をもつリストを1つ作成する
  ;; 例: 77 -> (77 135 865)
  (let((a n)(b 0)(c 0)
       (sum *current-quizzes-length*))
    (setf b (random sum))
    (setf c (random sum))
    ; 重複があった場合に再帰的に繰り返す
    (if (or (= a b) (= b c) (= a c))
        (make-3-uniques n)
         (list a b c))))

(defun make-quizzes-numbers()
  ;;　*quiz-numbers*の作成が目的
  ;;  例: ((21 432 544)(656 21 654)(55 66 122))
  (let* ((numbers (loop
                    for number
                    from 0
                    to (- *current-quizzes-length* 2)
                    collect number))
         (shuffled-numbers (shuffle numbers)))
    (setf *quiz-numbers*
          (loop
            repeat 100
            for number in shuffled-numbers
            collect(make-3-uniques number)))))

(defun make-quizzes-en()
  ;; 3択の英語一覧を作成する
  (setf *current-quizzes-en*
        (loop
          for arr in *quiz-numbers*
          collect(mapcar
                  #'(lambda(n)(second (nth n *current-words*)))
                  arr))))

(defun make-quizzes-ja()
  ;; 3択の日本語一覧を作成する
  (setf *current-quizzes-ja*
        (loop
          for arr in *quiz-numbers*
          collect(mapcar
                  #'(lambda(n)(fourth (nth n *current-words*)))
                  arr)))
  (setf *current-quizzes-ja*
        (loop
          for words in *current-quizzes-ja*
          collect(list(concatenate 'string "① " (first words))
                      (concatenate 'string "② " (second words))
                      (concatenate 'string "③ " (third words))))))

(defun make-a-quiz(current-quiz-no)
  ;; クイズ1問を作成する
  ;; 例: (make-a-quiz 10)
  ;;      => ("flattery" ("愛情深い" "採用，養子縁組" "おせじ") 2)
  ;;           →問題　　　　　→選択肢　　　　　　　　　　　　　　　→正解
  (labels((get-en-3options(current-quiz-no)
            (nth current-quiz-no *current-quizzes-en*))
          (get-ja-3options(current-quiz-no)
            (nth current-quiz-no *current-quizzes-ja*)))
    (let*((answer-no (+ 1 (random 3)))
          (ja-3-options (get-ja-3options current-quiz-no))
          (quiz (nth (- answer-no 1)(get-en-3options current-quiz-no))))
      (list quiz ja-3-options answer-no))))

(defun make-current-quizzes()
  (setf *current-quizzes*
        (loop
          for i
          from 0 to 99
          collect(make-a-quiz i))))

(defun save-wrong-quiz()
  ;; 間違えた問題を保存する
  (push current-quiz-no *wrong-quizzes*))

(defun init-quiz(level)
  ;レベルの設定
  (setf *current-level* level)
  ;クイズの作成
  (make-level-quizzes level)
  (make-quizzes-numbers)
  (make-quizzes-en)
  (make-quizzes-ja)
  (make-current-quizzes)
  "初期化終了")

; デフォルトではクイズのレベルを 1 で初期化する
(init-quiz 1)

(defun play-quiz2()
  (loop
    for i from 0 to 3
    do(progn(let((quiz (make-a-quiz i)))
              (format t "~A:~%|~{~A|~}~%"
                      (first quiz)
                      (second quiz))
              (if(equal (read-line) (write-to-string(third quiz)))
                 (format t "◯ ~%")
                 (format t "x ~%"))))))
