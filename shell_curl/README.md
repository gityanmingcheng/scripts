# curl 命令

> 简介

curl 是常用的命令行工具，用来请求 Web 服务器。它的名字就是客户端（client）的 URL 工具的意思。
它的功能非常强大，命令行参数多达几十种。如果熟练的话，完全可以取代 Postman 这一类的图形界面工具。

本文介绍它的主要命令行参数，作为日常的参考，方便查阅。内容主要翻译自《curl cookbook》。为了节约篇幅，下面的例子不包括运行时的输出，初学者可以先看我以前写的《curl 初学者教程》。

不带有任何参数时，curl 就是发出 GET 请求
```shell script
$ curl https://www.example.com
```

上面命令向**`www.example.com`**发出 **`GET`** 请求，服务器返回的内容会在命令行输出。

> -A

`-A`参数指定客户端的用户代理标头，即`User-Agent`。curl 的默认用户代理字符串是`curl/[version]`。
```shell script
$ curl -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36' https://google.com
```
上面命令将`User-Agent`改成 `Chrome` 浏览器。
```shell script
$ curl -A '' https://google.com
```
上面命令会移除`User-Agent`标头。

也可以通过`-H`参数直接指定标头，更改`User-Agent`。
```shell script
$ curl -H 'User-Agent: php/1.0' https://google.com
```
> -b

`-b`参数用来向服务器发送`Cookie`。
```shell script
$ curl -b 'foo=bar' https://google.com
```
上面命令会生成一个标头`Cookie: foo=bar`，向服务器发送一个名为`foo`、值为`bar`的 Cookie。
```shell script
$ curl -b 'foo1=bar;foo2=bar2' https://google.com
```

上面命令发送两个 Cookie。
```shell script
$ curl -b cookies.txt https://www.google.com
```
上面命令读取本地文件`cookies.txt`，里面是服务器设置的 Cookie（参见`-c`参数），将其发送到服务器。
> -c

`-c`参数将服务器设置的 Cookie 写入一个文件。
```
$ curl -c cookies.txt https://www.google.com
```
上面命令将服务器的 HTTP 回应所设置 Cookie 写入文本文件`cookies.txt`。

> -d

`-d`参数用于发送 POST 请求的数据体。
```shell script
$ curl -d'login=emma＆password=123'-X POST https://google.com/login
# 或者
$ curl -d 'login=emma' -d 'password=123' -X POST  https://google.com/login
```

使用`-d`参数以后，HTTP 请求会自动加上标头`Content-Type : application/x-www-form-urlencoded`。并且会自动将请求转为 POST 方法，因此可以省略`-X POST`。

`-d`参数可以读取本地文本文件的数据，向服务器发送。
```shell script
$ curl -d '@data.txt' https://google.com/login
```

