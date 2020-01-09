#!/bin/sh


##アラートログの初期化
echo 0 > td-agent.log
echo 0 > syslog.log
echo 0 > messages.log


##検索するワード
search=error

#デバッグ予告
echo "これから動作テストを行います" | ./slackbot.sh

while :
do

###########################################################################

	for i in `seq 3`
	do

		##複数のログを監視できるような処理
		case "$i" in
			1 ) 
				VAR=td-agent
				path=/var/log/td-agent/td-agent.log ;;
			2 )
				VAR=syslog
				path=/var/log/syslog ;;
			3 )
				VAR=messages
				path=/var/log/messages ;;
		esac

			##elasticsearchの情報を時間を指定して取得
			python ${VAR}.py

			##必要な情報の抽出
			cat ${VAR}.json | jq -r '.hits.hits[] | [._source.message] | @csv' > ${VAR}.csv

			##直前の3行がエラーを起こしていたらアラートを送信する準備をする
			error=$( tail -n 1000 ${VAR}.csv | grep -n $search | wc --lines )
			if [ $error -ge 10 ];then

				##最後に送信したアラートから1時間が経過していない場合にアラートを送信する
				now=$( date "+%s" )
				was=$( tail -n 1 ${VAR}.log )
				timer=$(( now-was ))
				if [ $timer -ge 3600 ];then
					echo send SlackAlert
					echo $pathにて\\nエラーが検出されました | ./slackbot.sh
					date "+%s" >> ${VAR}.log
				else
					echo already send SlackAlert
				fi

			else
			        echo not send SlackAlert
			fi

			##デバッグ用
			echo $error

	done

################################################################################

	##毎分監視
	sleep 10
done
exit 0

