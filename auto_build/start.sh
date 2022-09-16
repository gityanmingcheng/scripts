#!/bin/sh
currTime=$(date "+%Y-%m-%d %H:%M:%S")
currdate=$(date "+%Y-%m-%d-%H-%M")
#nohup ${java} -jar ${server} > ${log}  2>&1  &
shshell=$0
# gitbuld
GIT_PROJECT_DIR=""

# -j --java
# -s --server
# -l --log
java="java"
server=""
log=""

defaultlog="log.log"
SERVER_PATH=""
SERVER_NAME=""#sqc_coverage-1.0.0-SNAPSHOT.jar
PID=""


# 主流程
main(){
    getParams  "$@"
    checkParams
    initwork
    getPID
    restart
    exit 1
}



initwork(){
    SERVER_NAME=${server##*/}
    SERVER_PATH=${server%/*}
    if [ -z "$log" ]
    then
    log="${SERVER_PATH}/${defaultlog}"
    fi
    echo "$currTime---------->>SERVER_NAME=${SERVER_NAME}<<----------"
    echo "$currTime---------->>SERVER_PATH=${SERVER_PATH}<<----------"
    echo "$currTime---------->>log=${log}<<----------"
    
}


##PID
getPID(){
    echo "$currTime---------->>定位PID<<----------"
    PID=$(ps -ef | grep ${SERVER_NAME} | grep -v grep | awk '{print $2}')
      echo "$currTime----------PID=$PID "
}

##重启
restart(){
    echo "$currTime---------->>重启server<<----------"
    if [ -n "$PID" ]
    then
        echo "$currTime----------kill -9 $PID"
        $(kill -9 $PID)
    else
       echo "PID 等于 kong "
    fi
    #nohup ${javapath} -jar ${SERVER_PATH}${SERVER_NAME} > ${logpath}  2>&1  &

    echo "$currTime----------nohup ${java} -jar ${server} > ${log}  2>&1   &"
    nohup ${java} -jar ${server} > ${log}  2>&1  &
    echo "$currTime---------->>启动server完成<<----------"
}


getParams(){
    echo "$currTime---------->>getParams<<----------"
    while [ "$1" != "" ]; do
    case $1 in
        -j|--java)
        shift
        java=$1
        echo "java: $java========"
        ;;
        -s|--server)
        shift
        server=$1
        echo "server: $server========"
        ;;
        -l|--log)
        shift
        log=$1
        echo "log: $log========"
        ;;
        -h|--help)
        usage
        echo "Show Help"
        exit
        ;;
      *)
      
    esac
    shift
    done
}


checkParams(){
    echo "$currTime---------->>校验参数<<----------"
    if [ -z "$server" ]
    then
    echo "-s --server 必填========"
    usage
    exit 1
    fi
    echo "ss"
}

##帮助--help
usage() {
getslogan
  echo "usage: start.sh[
    [-j --java]       git 地址 (必填)
    [-s --server]     (必填)启动服务
    [-l --log]        log日志 default log.log
  ]"
}

getslogan(){
cat << EOF
       _                                               _
      | |                                             (_)
  ____| |__  _____ ____   ____ _   _ _____ ____  ____  _ ____   ____
 / ___)  _ \| ___ |  _ \ / _  | | | (____ |  _ \|    \| |  _ \ / _  |
( (___| | | | ____| | | ( (_| | |_| / ___ | | | | | | | | | | ( (_| |
 \____)_| |_|_____)_| |_|\___ |\__  \_____|_| |_|_|_|_|_|_| |_|\___ |
                        (_____(____/                          (_____|
EOF

}

main  "$@"

