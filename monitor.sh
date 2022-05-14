#!/bin/sh
currTime=$(date "+%Y-%m-%d %H:%M:%S")

MSGINFO=""

#-d
DF_AWK="/dev/disk3s5"
DF_rate=""
#磁盘阈值
DF_level="70"
mail_text=""
#mail_to="chengyanming@58.com,cailichao@58.com,panzhanghua@58.com"
mail_to="chengyanming@58.com,cailichao@58.com"
mail_cc="chengyanming@58.com"
mail_from="handy<MQC_monitor@58.com>"
SUBJECT="【monitor】MQC_磁盘报警"
#service
SERVER_DIR="/root/pzh"
SERVER_LOG="/root/pzh/nohup.out"
AGENT_LOG="/root/pzh/file/log/agent.log"
SERVER_JAR="imqc-agent-1.0-SNAPSHOT.jar"
SERVER_PID=$(ps -ef|grep imqc-agent|grep -v grep |awk '{print $2}')

#IP
addr_ip=$(ifconfig -a|grep inet|grep -v 127.0|grep -v inet6|awk '{print $2}'|tr -d "addr_ip:")


main(){
    monitorDF

}
monitorDF(){
     DF_rate=$(df -h |grep  $DF_AWK |awk {'print $5'})
     DF_rate=${DF_rate%\%*}
    echo "$currTime---------->>PID=$SERVER_PID<<----------"
     
    if [ "$DF_rate" -gt "$DF_level" ] ;then
     mail_text="
     报警I P：$addr_ip
     报警时间：$currTime
     报警内容：磁盘空间报警，磁盘使用率已经超过$DF_level%：
     $(df -h |grep  $DF_AWK)
     自愈能力：启动自动恢复程序......"
    
     sendMsg $mail_text
     #restart_server'
     mail_reply_msg="
     $addr_ip
     磁盘自动恢复
     恢复后磁盘空间如下：
     $(df -h |grep  $DF_AWK)
     "
     sendMsg $mail_reply_msg
    fi

}

sendMsg(){
    msg=$*
    echo $msg
    echo "$currTime---------->>推送邮件<<----------"
    
   sendmail -t -F MQC_monitor <<EOF
SUBJECT: ${SUBJECT}
TO: ${mail_to}
CC: ${mail_cc}
MIME-VERSION: 1.0
Content-type: text/plain
${msg}
EOF
}
restart_server(){
    echo "$currTime---------->>重启脚本<<----------"
    cd $SERVER_DIR
    echo "$currTime---------->>杀死进程--PID=$SERVER_PID<<----------"
    kill -9 $SERVER_PID
    echo "$currTime---------->>清理日志-$SERVER_LOG<<----------"
    echo "">$SERVER_LOG
    echo "$currTime---------->>清理日志-$AGENT_LOG<<----------"
    echo "">$AGENT_LOG
    echo "$currTime---------->>重启进程<<----------"
    nohup java -jar $SERVER_JAR &
}
sendMail(){
    echo "sendMail"

}

##帮助--help
usage() {
  echo "usage: monitor.sh[
  ]"
}

main  "$@"

