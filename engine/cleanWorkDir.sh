#!/bin/sh
currTime=$(date "+%Y-%m-%d %H:%M:%S")


WORK_DIR=""
RETAIN_TIME=""



main(){
    getParams "$@"
    checkParams
    getMsg

    
    #getPID

}
getMsg(){
    echo "$currTime---------->>拼接报文参数<<----------"
    echo "$currTime---------->>find $WORK_DIR -maxdepth 1 -mtime +$RETAIN_TIME |xargs rm -rf"
    find $WORK_DIR -maxdepth 1 -mtime +$RETAIN_TIME |xargs rm -rf
  }


getParams(){
    echo "$currTime---------->>getParams<<----------"
    while [ "$1" != "" ]; do
    case $1 in
        -d|--workdir)
        shift
        WORK_DIR=$1
        echo "WORK_DIR: $WORK_DIR========"
        ;;
        -t|--retaintime)
        shift
        RETAIN_TIME=$1
        echo "RETAIN_TIME: $RETAIN_TIME========"
        ;;
        -h|--help)
        usage
        echo "Show Help"
        exit
        ;;
      *)
        usage
        exit 1
    esac
    shift
    done
}

checkParams(){
    echo "$currTime---------->>校验参数<<----------"
    if [ -z "$WORK_DIR" ]
    then
    echo "-d  --pro_dir 必填========"
    usage
    exit 1
    fi
    
    if [ -z "$RETAIN_TIME" ]
    then
    echo "-t  --plat_type 必填========"
    usage
    exit 1
    fi
    echo "ss"
}

##帮助--help
usage() {
  echo "usage: cleanWorkDir.sh[
  [-d  --workdir]       工程路径地址 (必填)
  [-t  --retaintime]    留存时间
  ]"
}

main  "$@"

