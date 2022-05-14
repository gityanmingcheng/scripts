#!/bin/sh
currTime=$(date "+%Y-%m-%d %H:%M:%S")


file_name=""
WORK_ROOT="/opt/build/code_coverage_prj_src/"




main(){
    getParams "$@"
    checkParams
    getMsg


    #getPID

}
getMsg(){
    echo "$currTime---------->>拼接报文参数<<----------"
    echo "$currTime---------->>rm -rf $WORK_ROOT/$fileName"
    rm -rf $WORK_ROOT/$fileName
  }


getParams(){
    echo "$currTime---------->>getParams<<----------"
    while [ "$1" != "" ]; do
    case $1 in
        -f|--fileName)
        shift
        fileName=$1
        echo "fileName: $fileName========"
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
    if [ -z "fileName" ]
    then
    echo "-f  --fileName 必填========"
    usage
    exit 1
    fi

    echo "ss"
}

##帮助--help
usage() {
  echo "usage: delete.sh[
  [-f  --fileName]       工程路径地址 (必填)
  ]"
}

main  "$@"

