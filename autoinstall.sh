#!/bin/sh
#異常が発生した場合は即時終了
set -e

#INPUT=IN
IN=n
#OPTION=OP
OP=0

#Elasticsearchが既にsources.listに記載されているかチェック
Edir=/etc/apt/sources.list.d/elastic-7.x.list

echo "==========INSATALL SCRIPT START=========="

#OpenJDKのインストール
echo "Install OpenJDK ?(y/n)"
read IN
case $IN in
	y|Y)
	echo "Start Install OpenJDK..."
	apt install openjdk-11-jdk
	echo "Install OpenJDK is Completed!";;
	n|N)
	echo "Skip OpenJDK Install";;
esac

#公開鍵の取得
echo "Getting Elastic.co PublicKey..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

#apt-transport-httpsのインストール
echo "Install apt-transport-https ?(y/n)"
read IN
case $IN in
	y|Y)
	echo "Start Install apt-transport-https..."
	apt install apt-transport-https
	echo "Install apt-transport-https is Completed!";;
	n|N)
	echo "Skip apt-transport-https Install";;
esac

#Elasticsearchのインストール
echo "Install Elasticsearch ?(y/n)"
read IN
case $IN in
	y|Y)
	echo "Start Install Elasticsearch..."
	if [ -e $Edir ];then
        	echo "Skip! 既にソースリストに記載がありました"
		echo "/etc/apt/sources.list.d/elastic-7.x.listに記載が見つかりました"
	else
        	echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
	fi    
    	sudo apt update && apt install elasticsearch
	sudo dpkg -l | grep elasticsearch
	echo "Install Elasticsearch is Completed!";;
	n|N)
	echo "Skip Elasticsearch Install";;
esac

#Fluentdのインストール
echo "Install Fluentd(td-agent) ?(y/n)"
read IN
case $IN in
	y|Y)
	echo "Start Install Fluentd..."
	curl -L https://toolbelt.treasuredata.com/sh/install-debian-buster-td-agent3.sh | sh
	echo "Install Fluentd is Completed!";;
	n|N)
	echo "Skip Fluentd Install";;
esac

#Kibanaのインストール
echo "Install Kibana ?(y/n)"
read IN
case $IN in
	y|Y)
	echo "Start Install Kibana..."
	if [ -e $Edir ];then
		echo "Skip sources.list write.."
	else
		echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
		sudo apt update
	fi
	sudo apt install kibana
	echo "Install Kibana is Completed!";;
	n|N)
	echo "Skip Kibana Install";;
esac

#Python3-pipのインストール
python3 --version
echo "Install Python-pip(pip is Python's Comand) ?(y/n)"
read IN
case $IN in
	y|Y)
	echo "Start Install Python-pip..."
	sudo apt install python-pip
	pip install elasticsearch
	sudo apt install jq
	echo "Install Python-pip is Completed!";;
	n|N)
	echo "Skip Python-pip Install";;
esac


echo "==========END INSTALL SCRIPT=========="
