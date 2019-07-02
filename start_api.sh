#!/bin/sh

pid_file='/apps/pid/api.pid'
if [ -f $pid_file ];
then
	echo '重新启动api'
	cat $pid_file | awk '{print $1}' | xargs kill -9
	rm -f $pid_file
else
	echo '启动api'
fi

export ONTHEWAY_MYSQL_USERNAME='root'
export ONTHEWAY_MYSQL_PASSWORD='123456'
export ONTHEWAY_MYSQL_URL='jdbc:mysql://db.dev.jicu.vip:3306/on_the_way?useUnicode=true&characterEncoding=utf-8&useSSL=false&zeroDateTimeBehavior=convertToNull&serverTimezone=GMT%2B8'

nohup java -Dspring.profiles.active=production -jar /apps/java/api.jar -server -Xmx768M -Xms512M -Xmn512M -XX:MetaspaceSize=128M -XX:MaxMetaspaceSize=512M -Xss256K -XX:+DisableExplicitGC -XX:SurvivorRatio=1 -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:CMSFullGCsBeforeCompaction=0 -XX:+CMSClassUnloadingEnabled -XX:LargePageSizeInBytes=128M -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+PrintClassHistogram -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintHeapAtGC -Xloggc:/apps/log/gc.log &

tail -f /apps/log/on_the_way/app.log