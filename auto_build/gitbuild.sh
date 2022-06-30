#!/bin/sh
currTime=$(date "+%Y-%m-%d %H:%M:%S")

pro_dir=""
#-params
#git@igit.xxxxxx/xxx.git #-u --giturl
git_url=""
git_branch="master"
git_root_dir=""
build_active=""
build_cmd=""

git_file=""
target_jar=""


main(){
    getParams "$@"
    checkParams
    getgit_name
    # 下载代码
    gitcloneCode
    getbuildcmd
    # 构建代码
    gitBuild
    #getPID
    return $target_jar
}

##定位工程名
getgit_name(){
    tmp_git_pro=${git_url##*/}
    git_name=${tmp_git_pro%.*}
}

##定位代码工程 pro_dir
getpro_dir(){
    pro_dir_tmp=$(find ${git_root_dir} -name '.git'|grep ${git_name})
    pro_dir=${pro_dir_tmp%/*}
    echo "$currTime----------$pro_dir "
}

#定位构建后的包位置
findtarget_jar(){
    target_jar=$(find ${pro_dir} -maxdepth 2 -name '*.jar'|grep 'target')
    echo "$currTime----------target_jar=${target_jar} "
}
getbuildcmd(){
    if [ -z "$build_active" ]
    then
    build_cmd="mvn clean install "
    else
    build_cmd="mvn clean install package  -P ${build_active}"
    fi
    echo "$currTime---------->>${build_cmd}<<----------"
}

#MAVN 构建
gitBuild(){
    echo "$currTime---------->>开始构建git工程 MAVNE<<----------"
    getpro_dir
    if [ -z "$pro_dir" ]
    then
        exit 1
    fi
    cd ${pro_dir}
    echo "$currTime---------->>开始构建git pull工程 MAVNE<<----------"
    git pull
    echo "$currTime---------->>${build_cmd}<<----------"
    ${build_cmd}
    findtarget_jar
}

gitcloneCode(){
    getpro_dir
    echo "$currTime---------->>检测代码是否存在<<----------"
    if [ -z "${pro_dir}" ]
    then
        cd ${git_root_dir}
        echo "$currTime---------->>get git code=${git_url}<<----------"
        git clone -b ${git_branch} ${git_url}
        
    else
        echo "$currTime---------->>代码已经存在，直接切换分支<<----------"
        cd ${pro_dir}
        git checkout ${git_branch}
    fi
    #二次定位代码
    getpro_dir
}

getParams(){
    echo "$currTime---------->>getParams<<----------"
    while [ "$1" != "" ]; do
    case $1 in
        -u|--giturl)
        shift
        git_url=$1
        echo "git_url: $git_url========"
        ;;
        -b|--branch)
        shift
        git_branch=$1
        echo "git_branch: $git_branch========"
        ;;
        -d|--buildir)
        shift
        git_root_dir=$1
        echo "git_root_dir: $git_root_dir========"
        ;;
        -a|--active)# -a --active
        shift
        build_active=$1
        echo "build_active: $build_active========"
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
    if [ -z "$git_url" ]
    then
    echo "-u --giturl 必填========"
    usage
    exit 1
    fi
    if [ -z "$git_branch" ]
    then
    echo "-b --branch 必填========"
    usage
    exit 1
    fi
    if [ -z "$git_root_dir" ]
    then
    echo "-d --buildir 必填========"
    usage
    exit 1
    fi

    echo "ss"
}

#git_url="git@igit.xxxxxx/xxx.git" #-u --giturl
#git_branch="" #team_dev                                 #-b --branch
#git_root_dir=""#/data/coverage/sqc_coverage/test        #-d --buildir
#build_active="sanbox"# sanbox                           #-a --active
##帮助--help
usage() {
getslogan
  echo "usage: gitbuild.sh[
    [-u --giturl]       git 地址 (必填)
    [-b --branch]       git 需要打包的分支 default master
    [-d --buildir]      本地存放工程的路径 (必填)
    [-a --active]       构建 mvn -p @active@ default test
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

