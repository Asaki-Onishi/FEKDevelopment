# FEKDevelopment
## はじめに
お急ぎの方はこちら→
[簡易版・卒業研究について](./etc/about_sotsuron.md)
- FEKとは
  - Fluentd
  - Elasticsearch
  - Kibana  

上記の３つのフリーソフトウェアを組み合わせた情報システム基盤のことです。
## メモコーナー
成果物に関する適当なメモです。
- [卒業論文についてのメモ](./MEMO.md)  
卒業論文に関しての所感や作業中に感じたことを書いてあります。  
ex)Elasticsearchについて、NoSQLについて等の卒業論文内容に直接関わってくるもの。
- [そのほかのメモ保管所](./tech)  
作業中にふと思ったことを書き溜めいく場所です。  
卒業研究には直接は関係ないけど、発見したこと・思ったこと、Linux知識のあれこれ。
論文をまとめるまで利用したコマンドなどなど。

## 成果物  
FEK環境を半自動でインストールしてくれるスクリプト  
- 約2.5Gバイトの空き容量が必要です。  
- [インストールスクリプトについて](./About_InstallScript.md)  
- [完全版構築マニュアル（未完）](./manual.md)  
- [卒業論文評価用マニュアル](./new_manual.md)  

最新版の構築パッケージはこちら(一番上が最新です)
- [fek_package_m2.tar.gz](./fek_package_m2.tar.gz)  
- [fek_package_m1.tar.gz](./fek_package_m1.tar.gz)
- [卒業論文評価用fek_package](./fek_package.tar.gz)

---

## 工事中...

1月10日追記　下記のスクリプト群は旧バージョンです。最新版のパッケージは上記の**fek_package**です。  
もし、利用したい等の問い合わせがあれば大西(email:cist.b216.a.oonisi@gmail.com)までご連絡ださい。  

[strech.sh](./strech.sh)  
事前インストールスクリプト。インストールスクリプトを初期状態のDebianで稼働させようとすると、コマンドが足りずに途中で停止してしまうためこちらを先に起動させること。このスクリプトに限らず、インストールなどの作業を行う際には**apt update**を行うこと。  
  
[autoinstall.sh](./autoinstall.sh)  
インストールスクリプト本体。  
  
[autostart.sh](./autostart.sh)  
自動起動設定スクリプト。内容は簡単だが、面倒な自動起動設定をコマンド一発で行ってくれるスクリプト。  

動作検証中につき、利用にはご注意下さい。  
