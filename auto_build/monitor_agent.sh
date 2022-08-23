#!/bin/sh
currTime=$(date "+%Y-%m-%d %H:%M:%S")
currdate=$(date "+%Y-%m-%d-%H-%M")

PID=""
WORK_DIR="/opt/covagent/agentcode"
jar_name="mobile-cc-agentcode-1.0-SNAPSHOT.jar"

main(){
    getslogan

    getPID
    if [ "$PID" = "" ]; then
        echo "PID 等于 空  需要重启"
    fi

    if [ -n "$PID" ]
    then
        echo "$currTime----------kill -9 $PID"
    else
       echo "PID 等于 空 "
    fi
    #restart
    exit 1
}


##PID
getPID(){
    echo "$currTime---------->>定位PID<<----------"
    PID=$(ps -ef | grep "mobile-cc-agentcode" | grep -v grep | awk '{print $2}')
      echo "$currTime----------PID=$PID "
}


restart(){
    echo "$currTime---------->>重启进程<<----------"
    cd ${WORK_DIR}
    echo "$currTime---------->>  nohup java -jar ${jar_name} & <<----------"
    nohup java -jar ${jar_name} &
    getPID
    echo "$currTime---------->>重启完毕<<----------"
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