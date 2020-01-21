# ネットワークログ監査システム構築マニュアル ver2.1.0

## 目次
0. システム構築の概要  
甲. ネットワークログ監査システムの構成  
乙. 構築パッケージの構造  
丙. 開発環境について

1. ネットワークログ監査システムの展開  
1-1. 本マニュアルの記述に関しての留意点  
1-2. Debianパッケージの更新  
1-3. fek_packageの入手  
1-4. Makefileの展開  

2. FEK基盤各種の設定  
2-1. FEKの状態確認  
2-2. Fluentdの設定  

---

## 0 . システム構築の概要
本マニュアルはFEK基盤と付随する監視アプリケーションのインストール及びビルド作業を支援する手順書である。基本的な作業内容は後述するため、ここでは構築に関してどのような仕組みであるのか、どのようなソフトウェアを使用するのかを説明する。以後、監視アプリケーションを含むFEK基盤システムを**ネットワークログ監査システム**、本マニュアルで説明するネットワークログ監査システムを構築するプログラムパッケージを**構築パッケージ**と呼称する。  
> ログデータとは、OSを含めるシステムが稼働する際に出力されるデータ群のことであり、プロセス、エラー、履歴等が記録される。  

### 甲 . ネットワークログ監査システムの構成
ネットワークログ監査システムは、FEK基盤と監視アプリケーションから構成される。本システムの構成に含まれるソフトウェアは全て、GNUプロジェクトに代表されるオープンソースソフトウェア（以後OSSと記述）と自己開発したプログラムから成る。FEK基盤のFEKとは、システムを構成する基幹を担うOSSの頭文字から採ったものである。以下にOSSとプログラムの概要を記述する。

- Fluentd  
基盤を構成するOSSの中で、データの収集及び加工を担うソフトウェア。ログ分析システムにおいては、ログデータの受け取り及びデータの受け渡しを担当する。Fluentdに入力されたデータは、Elasticsearchに保存される。機能を拡張するプラグインが非常に充実していることが特徴である。利用者が必要な機能を必要なだけ導入することが出来るため、ソフトウェア本体だけでなくシステム自体に無駄が少なくコンパクトに実装できるのが強み。本システムでは、td-agnetと呼ばれるFluentdを最小限で構成したパッケージを利用する。

- Elasticsearch  
ログデータ分析システムではログデータの蓄積と管理を行うOSS。Elasticsearch自体は全文検索機能が主機能のソフトウェアであるが、NoSQLの性質上一般的なデータベースと比較してデータ格納に対する高い柔軟性を持つ。Elasticsearchを提供するElastic社は後述するKibana同様にサポートしており、ソフトウェア同士の親和性が非常に高い。

- Kibana  
Elasticsearchに格納されたデータを、分析しグラフ等に可視化するOSS。ネットワークログ監査システムでは、入力されたデータの状態を確認するために使用される。Kibana本体のデータはElasticsearch内に保存されている。そのため、外部クライアントに異常が発生した場合でも他のコンピュータから接続できる可用性を備える。

- 監視アプリケーション  
前述したOSSで構成されるFEK基盤を利用する監視システム。Fluentdにアクセスし、ログデータに任意の異常が確認された際に利用者へSlackを通じて通知を行う。


### 乙 . 構築パッケージの構造について
構築パッケージはシェルスクリプトで記載されており、makeコマンドによって展開することが出来る。本来、FEK基盤の構築には事前に必要なソフトウェアとコマンドをインストールする必要がある。しかし、構築パッケージではこれらの複雑な操作を簡略化し自動で必要な各種プログラムを取得・更新を行う。マニュアル閲覧者が、ネットワークログ監査システムを展開する際には、少ない手数と多少の待ち時間で構築を行うことが出来る。具体的な操作については別項に譲るが、本項では構築パッケージに含まれるプログラム群について多少の説明を行う。  
パッケージには以下のプログラムが含まれる。
> Makefile.in  
> configure.in  
> build.sh.in  
> install_strech.sh.in  
> start_set.sh.in  
> saerch.sh.in  
> es.py.in  
> slackbot.sh.in  
> kanshi_config.sh.in  

上から順番に  
- Makefile.in  
実行ファイル生成の核となるMakefileを生成するための設定ファイル。生成されたMakefileは、ネットワーク監査システムのパッケージの展開に必要なディレクトリを自動生成し、各種プログラムファイルの配置を行う。configureファイルを実行した後は「.in」拡張子が外れ、Makefileとなる。
- configure.in  
ネットワークログ監査システムが、構築環境の差異によって誤った設定をされるのを防ぐためのファイル。autoconfコマンドによってconfugureファイルを生成する。生成されたconfigureファイルを実行することで、Makefile.inの情報を基にMakefileが生成される。  
- build.sh.in  
構築パッケージの基幹ファイル。Makefileによるmakeコマンド実行後は他の「.in 」拡張子の付くファイルと同様にbuild.shファイルとなる。インターネットからFEKをダウンロードし、自動でインストールを行う。監視アプリケーションの動作に必要なファイルも同時にダウンロードする。  

- install_strech.sh.in  
makeコマンドにより生成されたbuild.shファイルを実行させることに先だって、各種必要なファイルやコマンドを自動インストールするファイル。  
- start_set.sh.in  
FEK基盤を自動起動するように設定するファイル。FEK基盤を構築したのちに自動で起動する。  
- search.sh.in  
監視アプリケーションの中核ファイル。読み取ったログデータに異常があった場合に、slackbot.shを動作させる。  
- es.py.in  
Elasticsearchに検索を掛け、検索結果を抽出するファイル。  
- slackbot.sh.in  
search.shが異常を検知した際に起動するslackにアクセスするためのファイル。  
- kanshi_config.sh.in  
監視アプリケーションのslackbotの設定に関するファイル。  

makeコマンドが実行後は、`/usr/local`下に`kanshi`ディレクトリと`/usr/local/etc`下に`fek`ディレクトリが作成される。

### 丙 . 試験構築環境について
ネットワークログ監査システムの構築にあたって、複数の環境での動作を検証するため仮想化ソフトウェアを利用した。試験構築に利用した環境であり、本システムを稼働させる環境としては推奨できない。あくまで参考ために記載しておく。

ホストマシン：Microsoft Surface Pro（第五世代）  

|OS|CPU|Memory|
|---|---|---|
|Windows10 home|Intel Corei5|8 GB|

VirtualBox  version 6.0.14  
ゲストOS概要  

|OS|CPU's Core|Memory|Strage|
|---|---|---|---|
|Debian10 buster(64bit)|2 Proceser|4096 MB|30 GB|

---

## 1 . 作業手順
本項目からは、具体的な構築手順を記述していく。作業の前提として、本構築マニュアルで利用するOSは**Debian10 buster 10.10(64bit)** を使用する。一部のプログラムは他のOSには対応していない。  

構築演習用コンピュータ仕様  

|Maker|Type|CPU|Memory|HDD|
|---|---|---|---|---|
|Hewlett-Packard|XL51DAV|Intel core i3-2120|4 GB|250 GB|

### 1-1 . 本マニュアルの記述に関しての留意点
以降の記述にはコマンド操作が多数含まれている。手順のコマンドラインの先頭記号に注意すること。
`$` が一般ユーザ、`#` が管理者（root）である。  

```
例  
$ apt update　一般ユーザーで実行。  
# apt update　管理者（root）で実行
```

また、ファイル内には`#説明等のコメント`や`#!/bin/sh`といった記述があることがある。これらはコマンドの指示ではなく、ファイル内の設定や注釈が記載されているだけである。  


### 1-2 . Debianパッケージの更新
作業のため、ユーザーの変更を行う。  
```
$ su
パスワード：*****
```
構築ツールを利用する前にDebianパッケージのアップデートを行う。  
```
パッケージリストの確認
# apt update

パッケージの更新
# apt upgrade

必要なコマンドをインストール
# apt install vim
# apt install make
# apt install autoconf
```
エラーを出力した際には、ネットワーク設定および`/etc/apt/sources.list`を確認すること。  
  

### 1-3 . fek_package入手
fek_packageをダウンロード或いは取得してください。  
パッケージは圧縮されているため、拡張子に「.tar.gz」と表記されている。  
fek_packageは場合によってはfek_package_m*（m1やm2といった何かしらの数字）と表記されていることがあるが、内容には変更点はない。以降はfek_packageと表記する。  

#### USBメモリからfek_package.tar.gzを取得する場合 
```
外部メディア（USBメモリ）ディレクトリへ移動
# cd /media/****（該当外部メディア）

homeディレクトリ下のユーザーディレクトリへコピー
# cp fek_package.tar.gz /home/***（ユーザー）

ユーザーディレクトリへ移動
# cd /home/***（ユーザー）

現在位置の確認(/home/***（ユーザー）であればOK)
# pwd
```

#### fek_package.tar.gzをダウンロードする場合
https://github.com/nsrg-fmlorg/students-2019/blob/master/LogAnalysysTeam/b2160340/Hangar/fek_package_m2.tar.gz  
上記のURLからダウンロードし、/home/***（ユーザー）下に配置する。
```
ダウンロードしたfek_packageを確認する
# cd /home/***（ユーザー）/ダウンロード

mvコマンドで移動
# mv fek_package.tar.gz /home/***（ユーザー）

ユーザーディレクトリへ移動
# cd /home/***（ユーザー）

現在位置の確認(/home/***（ユーザー）であればOK)
# pwd
```

#### fek_package.tar.gzを解凍する
```
gzipコマンドで解凍
# gzip -d fek_package.tar.gz

tarコマンドでアーカイブを展開
# tar -xvf fek_package.tar

lsコマンドできちんと展開出来ているか確認
# ls
fek_package fek_package.tar
```

### 1-4 . Makefileの展開
```
fek_packageディレクトリへ移動
# cd fek_package

autoconfコマンドを実行
# autoconf

生成されたconfigureファイルを実行
# ./configure

生成されたMakefileを実行
# make install

fekを構築
# make build
```

`make`コマンドを実行することで、installやbuildといったオプションの確認も出来る。

---

## 2 . FEK基盤各種の設定
ここまで、必要なソフトウェアとコマンドのダウンロードは完了した。ここからは、インストールしたFEK基盤の各種ソフトウェアの設定を行う。  

### 2-1 . FEKの状態確認
インストールされたFEKが起動しているか確認する。
```
Elasticsearchの状態を確認
# systemctl status elasticseach

Kibanaの状態を確認
# systemctl status kibana
```
**〇active**と緑字で表示されていれば問題ない。**〇Faild**と赤字で表示されている場合は、ソフトウェアが何らかの理由で停止しているため、再起動する必要がある。
```
例）Elasticsearchの再起動
# systemctl restart elasticsearch
```
設定を変更したり、他のソフトウェアと連動させる等停止させたい場合は下記の通りに行う。
```
例）Elasticsearchを停止
# systemctl stop elasticsearch
```
上記のコマンドを駆使し、FEKが全て正常に起動しているか確認する。

### 2-2 . Fluentdの設定
Fluentdは、インストールした直後ではそのまま利用することが出来ず設定を変更する必要がある。本システムでは、Fluentdの小型パッケージであるtd-agentを利用している。そのため、td-agentの設定を変更する。  
```
td-agent.serviceの設定を変更
# vim /usr/lib/systemd/system/td-agnet.service
```
出てきたエディタ画面にて、**[Service]** の直下に書いてある`User`と`Group`を書き換える。今回はrootユーザで利用出来るように変更を行う。  
#### 変更前
```
---中略---
[Service]
User=td-agent
Group=td-agent
```
#### 変更後
```
---中略---
[Service]
User=root
Group=root
```
変更後、td-agent.serviceを再起動させる。
```
td-agentの再起動
# systemctl restart td-agent.service

td-agentの状態を確認
# systemctl status td-agent
```
active表示を確認出来ればFluentd（td-agent）の設定は完了した。

---