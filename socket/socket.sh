#!/bin/sh
currTime=$(date "+%Y-%m-%d %H:%M:%S")

MSGINFO=""
PID=""
#-d
pro_dir=""
ici_status=""
ici_message=""
server_ip=""
plat_type=""
host="127.0.0.1"
SocketCommand="nc -w 2 -v $host 13333"


main(){
    getParams "$@"
    checkParams
    getMsg
    echo "$MSGINFO"
    sendMsg
    #getPID

}
getMsg(){
    echo "$currTime---------->>拼接报文参数<<----------"
    MSGINFO="{\"action\":\"1\",\"params\":{\"pro_dir\":\"$pro_dir\",\"ici_message\":\"$ici_message\",\"server_ip\":\"$server_ip\",\"plat\":\"$plat_type\",\"ici_status\":\"$ici_status\"}}"
    
    #MSGINFO='{"action":"1","params":{"pro_dir":"$pro_dir","ici_message":"$ici_message","server_ip":"$server_ip","plat":"$plat_type","ici_status":"$ici_status"}}'
}
sendMsg(){
    echo "$currTime---------->>推送socket<<----------"
    echo  "$MSGINFO"|$SocketCommand
    echo "$currTime---------->>推送socket结束<<----------"
}

##PID
getPID(){
    echo "$currTime---------->>定位PID<<----------"
    PID=$(ps -ef | grep $SocketCommand | grep -v grep | awk '{print $2}')
      echo "$currTime----------PID=$PID "
}

getParams(){
    echo "$currTime---------->>getParams<<----------"
    while [ "$1" != "" ]; do
    case $1 in
        -d|--pro_dir)
        shift
        pro_dir=$1
        echo "pro_dir: $pro_dir========"
        ;;
        -s|--ici_status)
        shift
        ici_status=$1
        echo "ici_status: $ici_status========"
        ;;
        -m|--ici_message)
        shift
        ici_message=$1
        echo "ici_message: $ici_message========"
        ;;
        -i|--server_ip)
        shift
        server_ip=$1
        echo "server_ip: $server_ip========"
        ;;
        -t|--plat_type)
        shift
        plat_type=$1
        echo "plat_type: $plat_type========"
        ;;
        -h|--help)
        usage
        echo "Show Help"
        exit
        ;;
      *)
#        usage
#        exit 1
    esac
    shift
    done
}
checkParams(){
    echo "$currTime---------->>校验参数<<----------"
    if [ -z "$pro_dir" ]
    then
    echo "-d  --pro_dir 必填========"
    usage
    exit 1
    fi
    if [ -z "$server_ip" ]
    then
    echo "-i  --server_ip 必填========"
    usage
    exit 1
    fi
    if [ -z "$plat_type" ]
    then
    echo "-t  --plat_type 必填========"
    usage
    exit 1
    fi
    if [ -z "$ici_status" ]
    then
    echo "-s  --ici_status 必填========"
    usage
    exit 1
    fi


    echo "ss"
}

##帮助--help
usage() {
  echo "usage: socket.sh[
  [-d  --pro_dir]       工程路径地址 (必填)
  [-m  --ici_message]   beta 构建信息
  [-i  --server_ip]     beta 机器IP(必填)
  [-s  --ici_status]    beta 构建状态(必填)
  [-t  --plat_type]     构建机器类型 1-IOS，0-ANDROID(必填)
  ]"
}

main  "$@"

