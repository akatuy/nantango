# Development

## Dictionary

Please follow the followinf steps for data injection:

```bash
$ sqlite3 nantango.db
SQLite version 3.28.0 2019-04-15 14:49:49
Enter ".help" for usage hints.
sqlite> .mode csv
sqlite> .import data.csv quiz
sqlite> .exit
```

## Setting up

```bash
$ docker build .

$ docker run -it -v `pwd`:/common-lisp -p 4005:4005 -p 5000:5000　*ImageiD*

~/common-lisp # ros install fukamachi/utopian

~/common-lisp/ # utopian new nantango
Description: Utopian sample project
Author: t-cool
Database [sqlite3]: 
License: MIT

New project is created at '/root/.roswell/local-projects/nantango/'.

~/common-lisp # cd nantango

~/common-lisp/nantango # qlot install

~/common-lisp/nantango # qlot exec ros -S . run -s swank -e \
'(swank:create-server :dont-close t :interface "0.0.0.0")'

CL-USER> (ql:quickload :nantango)
To load "nantango":
  Load 1 ASDF system:
    nantango
; Loading "nantango"
........To load "nantango/controllers/root":
  Load 1 ASDF system:
    nantango/controllers/root
; Loading "nantango/controllers/root"
(:NANTANGO)

CL-USER> (nantango/controllers/quizzes:play-quiz)
said:
|① 100|② sayの過去・過去分詞形|③ 長い，長く|
2 
◯
so:
|① とても，だから|② 30，30の|③ 一対，1対|
3 
x
```

