#!/bin/sh
currTime=$(date "+%Y-%m-%d %H:%M:%S")
currdate=$(date "+%Y-%m-%d-%H-%M")
#nohup ${JAVA_PATH} -jar ${SERVER_PATH}${SERVER_NAME} > ${LOG_NAME}  2>&1  &

# server config
GIT_PROJECT_DIR=""
JAVA_PATH="/opt/soft/jdk/jdk1.8.0_45/bin/java"
SERVER_PATH="/data/coverage/sqc_coverage/"
SERVER_NAME="sqc_coverage-1.0.0-SNAPSHOT.jar"
LOG_NAME="/data/coverage/sqc_coverage/logs/coverage.log"
SERVER_BACK_JAR_DIR="$SERVER_PATH/back/"

PID=""
####gitbuild config
git_url="git@xxxxx/xx.git"
git_branch="team_dev"
git_root_dir="/data/coverage/aaa/gitproject"
build_active="sanbox"
##script
SCRIPT_DIR="/data/coverage/aa/script/"
budild_script="gitbuild.sh"
start_script="start.sh"
budild_jar=""
pro_dir=""

build="0"
main(){
    getslogan
        getParams "$@"
    if [ "$build" = "1" ]; then
        gitbuild
        backjar
        move_jar
    fi
    getPID
    restart
    exit 1
}


##定位代码工程 pro_dir
getpro_dir(){
    tmp_git_pro=${git_url##*/}
    git_name=${tmp_git_pro%.*}
    getgit_name
    echo "$currTime----------定位包位置：find ${git_root_dir} -name '.git'|grep ${git_name} "
    pro_dir_tmp=$(find ${git_root_dir} -name '.git'|grep ${git_name})
    pro_dir=${pro_dir_tmp%/*}
    echo "$currTime----------$pro_dir "
}
#定位构建后的包位置
findtarget_jar(){
    getpro_dir
    echo "$currTime----------target_jar=find ${pro_dir} -maxdepth 2 -name '*.jar'|grep 'target'"
    budild_jar=$(find ${pro_dir} -maxdepth 2 -name '*.jar'|grep 'target')
    echo "$currTime----------target_jar=${target_jar} "
}

gitbuild(){
    echo "$currTime---------->>sqc_coverage打包编辑<<----------"
    shcmd="sh ${SCRIPT_DIR}/${budild_script} -u ${git_url} -b ${git_branch} -d ${git_root_dir} -a ${build_active}"
    
    echo "$currTime---------->>shcmd=${shcmd}<<----------"
    ${shcmd}
    findtarget_jar

    if [ -z "${budild_jar}" ] ;then
        echo "$currTime---------->>未发现构建包 stop<<----------"
        exit 1
    fi
}



##备份
backjar(){
    echo "$currTime---------->>备份旧包<<----------"
    cd $SCRIPT_DIR
    echo "$currTime----------mkidr $SERVER_BACK_JAR_DIR "
    mkdir $SERVER_BACK_JAR_DIR
    cp ${SERVER_PATH}${SERVER_NAME} ${SERVER_BACK_JAR_DIR}${SERVER_NAME}.${currdate}
    echo "$currTime----------cp ${SERVER_PATH}${SERVER_NAME} ${SERVER_BACK_JAR_DIR}${SERVER_NAME}.${currdate} "

}
move_jar(){
    echo "$currTime---------->>cp 启动包<<----------"
    echo "$currTime---------->>\cp ${budild_jar} to  ${SERVER_PATH}${SERVER_NAME}<<----------"
    \cp -rf ${budild_jar} ${SERVER_PATH}${SERVER_NAME}
}


##重启
restart(){
    echo "$currTime---------->>重启server<<----------"
    #./start_script  -j ${JAVA_PATH} -s ${SERVER_PATH}${SERVER_NAME} -l ${LOG_NAME}
    shcmd="sh ${SCRIPT_DIR}/${start_script} -j ${JAVA_PATH} -s ${SERVER_PATH}${SERVER_NAME} -l ${LOG_NAME}"
    echo "$currTime---------->>shcmd=${shcmd}<<----------"
    ${shcmd}
    echo "$currTime---------->>启动server完成<<----------"
}



getParams(){
    echo "$currTime---------->>getParams<<----------"
    while [ "$1" != "" ]; do
    case $1 in
        -b|--build)
        shift
        build=$1
        echo "build: $build========"
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



##帮助--help
usage() {
  echo "usage: start.sh[
    [-b --build]      need build git default 0 否
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

