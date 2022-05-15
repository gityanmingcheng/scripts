# socket 
通过shell 脚本调用socket接口



## 核心代码
```shell script
MSGINFO: 推送的协议数据
host : 接口地址

echo  "$MSGINFO"|nc -w 2 -v $host 13333
```


```shell script
usage: socket.sh[
  [-d  --pro_dir]       工程路径地址 (必填)
  [-m  --ici_message]   beta 构建信息
  [-i  --server_ip]     beta 机器IP(必填)
  [-s  --ici_status]    beta 构建状态(必填)
  [-t  --plat_type]     构建机器类型 1-IOS，0-ANDROID(必填)
  ]

```
