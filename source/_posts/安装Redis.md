---
title: 安装Redis
date: 2018-06-23 15:08:44
tags: Linux
---

Redis官网链接 <https://redis.io/>  

### 一、下载安装Redis

```shell
cd /usr/local/download
wget http://download.redis.io/releases/redis-4.0.9.tar.gz
tar -zxvf redis-4.0.9.tar.gz -C /usr/local/redis
cd /usr/local/redis
make
```

### 二、配置和初始化Redis

```shell
[root@localhost redis]# cd utils/
[root@localhost utils]# ./install_server.sh 
Welcome to the redis service installer
This script will help you easily set up a running redis server

Please select the redis port for this instance: [6379] 3680
Please select the redis config file name [/etc/redis/3680.conf] 
Selected default - /etc/redis/3680.conf
Please select the redis log file name [/var/log/redis_3680.log] 
Selected default - /var/log/redis_3680.log
Please select the data directory for this instance [/var/lib/redis/3680] 
Selected default - /var/lib/redis/3680
Please select the redis executable path [/usr/bin/redis-server] 
Selected config:
Port           : 3680
Config file    : /etc/redis/3680.conf
Log file       : /var/log/redis_3680.log
Data dir       : /var/lib/redis/3680
Executable     : /usr/bin/redis-server
Cli Executable : /usr/bin/redis-cli
Is this ok? Then press ENTER to go on or Ctrl-C to abort.
Copied /tmp/3680.conf => /etc/init.d/redis_3680
Installing service...
Successfully added to chkconfig!
Successfully added to runlevels 345!
Starting Redis server...
Installation successful!
```

### 三、设置密码

```shell
[root@localhost utils]# vi /etc/redis/3680.conf
requirepass ggsongnail
bind 127.0.0.1 或者 bind 0.0.0.0
```

### 四、常规启动

```shell
$ ln /usr/local/redis/src/redis-cli /usr/bin/redis-cli
$ ln /etc/init.d/redis_3680 /usr/bin/redis-server
```

### 五、常见问题

- /bin/sh: cc: command not found﻿

  ```shell
  解决方法 安装gcc：
  yum install -y gcc
  查看gcc是否安装成功：
  rpm -qa|grep gcc
  ```

- [root@localhost utils]# redis-server stop
  Stopping ...
  (error) NOAUTH Authentication required.

  ```shell
  解决方法 修改/etc/init.d/redis_3680
  增加
  $CLIEXEC -a "ggsongnail" -p $REDISPORT shutdown
  如下所示
  #!/bin/sh
  #Configurations injected by install_server below....
  EXEC=/usr/bin/redis-server
  CLIEXEC=/usr/bin/redis-cli
  PIDFILE=/var/run/redis_3680.pid
  CONF="/etc/redis/3680.conf"
  REDISPORT="3680"
  $CLIEXEC -a "ggsongnail" -p $REDISPORT shutdown
  
  然后再次执行
  [root@localhost utils]# redis-server stop
  Could not connect to Redis at 127.0.0.1:3680: Connection refused
  Stopping ...
  Could not connect to Redis at 127.0.0.1:3680: Connection refused
  Redis stopped
  ```

