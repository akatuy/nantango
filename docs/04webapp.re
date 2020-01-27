= Web アプリケーションの開発

== 開発環境の構築

本章では、デプロイの環境に合わせてアプリケーションを開発するために、
次の構成のように Docker を用います。

//emlist{
イメージ
＊Docker コンテナ内でLisp アプリケーションを動作させて、ローカル環境の Lem から接続して開発を進める様子を図で描く。
//}

Docker の公式サイトを参考に Docker Desktop をインストールして、次のセクションにお進みください。

=== Docker イメージの作成

SBCL と Roswell がインストールされた fukamachi/sbcl イメージを元に、
Qlot と Utopian がインストールされたイメージを作成します。

Dockerfile は、次の通りです。

//cmd{
FROM fukamachi/sbcl:2.0.0-alpine

# common-lisp ディレクトリの作成
RUN mkdir ${HOME}/common-lisp && \
    ln -s ${HOME}/common-lisp common-lisp

# コンテナ起動時のディレクトリを common-lispフォルダにする
WORKDIR ${HOME}/common-lisp

# Utopian のインストール
RUN ros install fukamachi/qlot && \
    ros install fukamachi/utopian

# Web アプリの開発用ポートを expose する
EXPOSE 4005 5000
//}

上記の Dockerfile からビルドした Docker イメージを元にコンテナを起動します。
-v オプションをつけて、コンテナ内で生成するコードをローカル環境に残します。
また、-p オプションをつけてポートフォワードを行います。

//cmd{
$ docker build .
(Dockerイメージの ID を確認する)

$ docker run -it -v `pwd`:/common-lisp -p 4005:4005 -p 5000:5000　DockerイメージのID
~/common-lisp # 
//}

== Web アプリの開発

では、Utopian を用いて Web アプリの開発を進めます。

=== Utopian

Utopian がインストールされていることを確認します。

//cmd{
~/common-lisp # ros install fukamachi/utopian
//}

=== Web アプリの雛形生成

Utopian の new コマンドを用いて、プロジェクトの雛形を生成します。

//cmd{
~/common-lisp/ # utopian new nantango
Description: Utopian sample project
Author: t-cool
Database [sqlite3]: 
License: MIT

New project is created at '/root/.roswell/local-projects/nantango/'.
//}

実行後、プロジェクトの雛形が生成されます。
生成されるファイルと役割は次の通りです。

//cmd{
nantango
├── README.md 
├── app.lisp # ???
├── config　# アプリケーションの設定
│   ├── application.lisp # 全体の設定
│   ├── environments
│   │   └── local.lisp # 開発時の環境設定
│   └── routes.lisp # ルーティングの設定
├── controllers # コントローラー関連のコードを置くフォルダ
│   └── root.lisp
├── db # データベース関連(マイグレーションや SQLite の db ファイル等)
├── main.lisp # ???
├── models # モデル関連のコードを置くフォルダ
├── nantango.asd # アプリケーションのシステムファイル
├── public # 画像等の静的なファイルを置くためのフォルダ
├── qlfile # Qlot で依存ライブラリのバージョン情報を記述するためのファイル
└── views # ビュー関連のコードを置くフォルダ
    └── root.lisp
//}

=== 完成イメージ

nantango の完成イメージは次の通りです。

|TOP|学習画面|学習結果の画面|
|:---:|:---:|:---:|
|![](https://github.com/t-cool/nantango1/raw/master/img/screenshotA.png)|![](https://github.com/t-cool/nantango1/raw/master/img/screenshotB.png)|![](https://github.com/t-cool/nantango1/raw/master/img/screenshotC.png)|

nantango の利用の流れは次の通りです。

1. トップページで学習するレベルを選択する。

2. 三択クイズで問題に回答する。

3. 間違えた問題のみを抽出して結果画面で表示する。

=== 開発環境

まず、nantango のディレクトリーに移動します。

//cmd{

~/common-lisp # cd nantango
//}

移動後、Qlot を用いてプロジェクトのフォルダに依存ライブラリをダウンロードします。
`qlot install` を実行後、プロジェクトフォルダ内の `.qlot/` フォルダに依存ライブラリがダウンロードされます。

//cmd{
~/common-lisp/nantango # qlot install
//}

次のように SWANK サーバを起動します。

//cmd{
~/common-lisp/nantango # qlot exec ros -S . run -s swank -e \
'(swank:create-server :dont-close t :interface "0.0.0.0")'
//}

では、ローカル環境にインストールした Lem から、Docker コンテナで起動しているSWANK サーバに接続します。

Lem 上で `M-x slime-connect` と打った後、処理系に qlot/sbcl を指定して、IPアドレスを 127.0.0.1 、
ポートを 4005 番に指定して接続します。
起動した REPL で nantango をロードします。

//emlist{
CL-USER> (ql:quickload :nantango)
To load "nantango":
  Load 1 ASDF system:
    nantango
; Loading "nantango"
........To load "nantango/controllers/root":
  Load 1 ASDF system:
    nantango/controllers/root
; Loading "nantango/controllers/root"
(省略)
(:NANTANGO)
//}

これで 開発環境が整いました。
次のセクションでは、雛形を編集しながら Web アプリケーションを開発していきます。

=== Controller(C)

//emlist{
CL-USER> (nantango/controllers/quizzes:play-quiz)
said:
|① 100|② sayの過去・過去分詞形|③ 長い，長く|
2 
◯
so:
|① とても，だから|② 30，30の|③ 一対，1対|
3 
x
//}

=== View(V)

Utopian のデフォルトのテンプレートエンジン LSX を用いて、ページを作成します。

必要なページは、トップページ、クイズのページ、結果表示のページの３点です。

では、それぞれを実装していきましょう。

==== トップページ

//emlist{
//}

==== クイズのページ

//emlist{
//}

==== 結果表示のページ

//emlist{
//}


== まとめ

本章では、Web 開発フレームワーク Utopian を用いて、英語クイズアプリを開発してきました。次章以降、本章で開発したアプリケーションのテストやデプロイ方法について解説します。

