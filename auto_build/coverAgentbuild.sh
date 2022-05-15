#!/bin/sh
currTime=$(date "+%Y-%m-%d %H:%M:%S")

SCRIPT_DIR=""
BACK_JAR_DIR=""
URL=""
PID=""
JAR=""
OLD_JAR=""

init(){
    SOURCE="$0"
    while [ -h "$SOURCE"  ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /*  ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
    BACK_JAR_DIR="$SCRIPT_DIR/back/"
    echo "$currTime----------$SCRIPT_DIR----------"
}

main(){
    getslogan
    init
    while [ "$1" != "" ]; do
          
    case $1 in
      -u|--url)
        shift
        URL=$1
        echo "$URL========"
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
    
    if [ -z "$URL" ]
    then
    echo "-u  --url 必填========《你个傻逼》"
    usage
    exit 1
    fi
    
    initWork
    backjar
    download
    unzip
    getPID
    getjar
    restart
    exit 1
}


initWork(){
    cd $SCRIPT_DIR
    echo "$currTime---------->>初始化构建空间<<----------"
    echo "$currTime----------find . -name file|xargs rm -rf "
    find . -name file|xargs rm -rf
    echo "$currTime----------find . -name lib|xargs rm -rf "
    find . -name lib|xargs rm -rf
    echo "$currTime---------->>初始化构建空间完成<<----------"
}


##备份
backjar(){
    echo "$currTime---------->>备份旧包<<----------"
    cd $SCRIPT_DIR
    echo "$currTime----------mkidr $BACK_JAR_DIR "
    mkdir $BACK_JAR_DIR
    OLD_JAR=$(find . -name '*agentcode*jar'|grep -v back)
    mv $OLD_JAR $BACK_JAR_DIR
    echo "$currTime----------mv $OLD_JAR $BACK_JAR_DIR "
}



##下载
download(){
    echo "$currTime---------->>下载文件<<----------"
    #curl http://testv3.58v5.cn/NPoPJiHgFNouN/mobilecc/1.0.1agentcode.tar.bz2 -P $SCRIPT_DIR
    echo "$currTime----------curl -o $SCRIPT_DIR/${URL##*/} $URL "
    #wget $URL -P $SCRIPT_DIR
    curl -o $SCRIPT_DIR/${URL##*/} $URL
}

##解压
unzip(){
    echo "$currTime---------->>解压文件<<----------"
    echo ${URL##*/}
    cd $SCRIPT_DIR
    tar -xjf ${URL##*/} -C $SCRIPT_DIR
    echo "$currTime----------tar -xjf ${URL##*/} -C $SCRIPT_DIR----------"
    echo "$currTime---------->>迁移压缩文件<<----------"
    mv ${URL##*/} $BACK_JAR_DIR
    echo "$currTime----------mv ${URL##*/} $BACK_JAR_DIR "
}
##PID
getPID(){
    echo "$currTime---------->>定位PID<<----------"
    PID=$(ps -ef | grep "agentcode" | grep -v grep | awk '{print $2}')
      echo "$currTime----------PID=$PID "
}

##找到启动文件
getjar(){
    JAR=$(find . -name '*agentcode*jar'|grep -v back|grep -v lib|grep -v file)
    echo "$currTime----------$JAR "
}
##重启
restart(){
    echo "$currTime---------->>重启server<<----------"
    if [ -n "$PID" ]
    then
        echo "$currTime----------kill -9 $PID"
        $(kill -9 $PID)
    else
       echo "PID 等于 空 "
    fi

    echo "$currTime----------cd ${JAR%/*} "
    echo "$currTime----------nohup java -jar ${JAR##*/} &"
    cd ${JAR%/*}
    nohup java -jar ${JAR##*/} &
    echo "$currTime---------->>启动server完成<<----------"
}
##帮助--help
usage() {
  echo "usage: diffcoverbuild.sh [[-u  url] ]"
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

