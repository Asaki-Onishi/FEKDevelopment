#!/bin/sh
#異常が発生した場合は即時終了
set -e

#INPUT=IN
IN=n
#OPTION=OP
OP=0
#auto daemon setting
auto_e=0
auto_f=0
auto_k=0

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
	auto_e=1
	echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
	sudo apt update && apt install elasticsearch
	sudo dpkg -l | grep elasticsearch
	echo "Install Elasticsearch is Completed!";;
	n|N)
	echo "Skip Elasticsearch Install";;
esac

#Elasticsearchの自動起動有効化
if [ $auto_e = 1 ];then
	echo "Elasticsearch AutoStarting Setting ?(y/n)"
	read OP
	case $OP in
		y|Y)
		echo "Elasticsearch Service AutoStarted..."
		#sudo update-rc.d elasticsearch defaults 95 10
		#sudo service elasticsearch start
		#sudo service elasticsearch status
		sudo /bin/systemctl daemon-reload
		sudo /bin/systemctl enable elasticsearch.service
		echo "Completed!";;
		n|N)
		echo "Skip Setting!";;
	esac
fi

#Fluentdのインストール
echo "Install Fluentd(td-agent) ?(y/n)"
read IN
case $IN in
	y|Y)
	echo "Start Install Fluentd..."
	auto_f=1
	curl -L https://toolbelt.treasuredata.com/sh/install-debian-buster-td-agent3.sh | sh
	echo "Install Fluentd is Completed!";;
	n|N)
	echo "Skip Fluentd Install";;
esac

#Fluentdの自動起動有効化
if [ $auto_f = 1 ];then
	echo "Fluentd AutoStarting Setting ?(y/n)"
	read OP
	case $OP in
		y|Y)
		echo "Fluentd Service AutoStarted..."
		sudo /bin/systemctl daemon-reload
		sudo /bin/systemctl enable td-agent.service
		echo "Completed!";;
		n|N)
		echo "Skip Setting!";;
	esac
fi

#Kibanaのインストール
echo "Install Kibana ?(y/n)"
read IN
case $IN in
	y|Y)
	echo "Start Install Kibana..."
	auto_k=1
	if [ $auto_e = 0];then
		echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
		sudo apt update
	fi
	sudo apt install kibana
	echo "Install Kibana is Completed!";;
	n|N)
	echo "Skip Kibana Install";;
esac

#Kibanaの自動起動有効化
if [ $auto_k = 1 ];then
	echo "Kibana AutoStarting Setting ?(y/n)"
	read OP
	case $OP in
		y|Y)
		echo "Kibana Service AutoStarted..."
		sudo /bin/systemctl daemon-reload
		sudo /bin/systemctl enable kibana.service
		echo "Completed!";;
		n|N)
		echo "Skip Setting!";;
	esac
fi

echo "==========END INSTALL SCRIPT=========="
