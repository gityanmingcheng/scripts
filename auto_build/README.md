# auto_build
#### 自动构建相关脚本
## 1.delete.sh 

自动删除脚本 

    delete.sh -f /opt/work
    
![1](../static/auto_build/1.png)

## 2.cleanWorkDir.sh 
清理工作空间


    cleanWorkDir.sh -f /opt/work -t 3 

```
usage: cleanWorkDir.sh[
  [-d  --workdir]       工程路径地址 (必填)
  [-t  --retaintime]    留存时间
  ]
```

## 3.coverAgentbuild.sh 
自动部署中间件


## 4.gitbuild.sh
git自动拉java工程并mavn编译出包

```shell script
    [-u --giturl]       git 地址 (必填)
    [-b --branch]       git 需要打包的分支 default master
    [-d --buildir]      本地存放工程的路径 (必填)
    [-a --active]       构建 mvn -p @active@ default test
```
```shell script
sh gitbuild.sh -u git@xxxxx.git -b team_dev  -d /Users/sqc_coverage -a test
```

# start.sh 

start.sh  帮助运维 kill 掉老服务启动新服务
```shell script
    [-j --java]       git 地址 (必填)
    [-s --server]     (必填)启动服务
    [-l --log]        log日志 default log.log
```
```shell script
./start.sh   -j xxxxx/java -s xxxx/xxx.jar -l /opt/build/log/log.log
```

# restart.sh

作为重启的调用脚本
````shell script
./restart.sh  重启
./restart.sh -b 1 # 重新构建且重启
````

```shell script
# 相关配置
JAVA_PATH="/opt/soft/jdk/jdk1.8.0_45/bin/java" # jdk
SERVER_PATH="/data/coverage/sqc_coverage/"      # 服务路径
SERVER_NAME="sqc_coverage-1.0.0-SNAPSHOT.jar"   #服务名
LOG_NAME="/data/coverage/sqc_coverage/logs/coverage.log"# 日志位置
SERVER_BACK_JAR_DIR="$SERVER_PATH/back/"         # 服务备份路径

PID=""
####gitbuild config
git_url="git@xxxxx/xx.git"                      #git 地址
git_branch="team_dev"                           # 选择分支
git_root_dir="/data/coverage/aaa/gitproject"    # 工程存放位置
build_active="sanbox"                           #maven 打包环境
##script
SCRIPT_DIR="/data/coverage/aa/script/"          # 脚本存放路径
budild_script="gitbuild.sh"                     # 构建脚本名
start_script="start.sh"                         # 启动脚本名
```


| 姓名| 年龄| 性别 | 电话|
|----: | ---- | ---- | ------------ |
| 张三 | 18 | 男 | 123456789121 |
