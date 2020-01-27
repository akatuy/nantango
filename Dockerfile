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
