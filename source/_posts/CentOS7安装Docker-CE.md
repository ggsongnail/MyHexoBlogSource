---
title: CentOS7安装Docker CE
date: 2018-08-25 19:25:19
tags: Docker
---

### 官网

<https://docs.docker.com/install/linux/docker-ce/centos/>

### OS版本要求

```shell
[root@localhost ~]# uname -r ##查询操作系统内核版本信息
3.10.0-514.el7.x86_64
[root@localhost ~]# cat /etc/centos-release ##查看CentOS的版本号
CentOS Linux release 7.3.1611 (Core) 
[root@localhost ~]# getconf LONG_BIT ##查看系统操作位数
64
```

安装Docker CE需要maintained version 的centos7，Archived versions 的不会支持

### 卸载旧版本Docker

```shell
[root@localhost ~]# yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
```

如果你之前安装过Docker请 执行这一步骤。之前的 images, containers, volumes,networks 会被保留在/var/lib/docker/

### Set Up The Docker Repository

1、安装必要的packages

```shell
[root@localhost ~]# yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```

2、建立稳定的repository

```shell
[root@localhost ~]# yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
Loaded plugins: fastestmirror
adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
grabbing file https://download.docker.com/linux/centos/docker-ce.repo to /etc/yum.repos.d/docker-ce.repo
repo saved to /etc/yum.repos.d/docker-ce.repo
```

3、Enable the **edge** and **test** repositories

```shell
[root@localhost ~]# yum-config-manager --enable docker-ce-edge
[root@localhost ~]# yum-config-manager --enable docker-ce-test
```

### 安装Docker

```shell
[root@localhost ~]# yum install docker-ce
```

可能由于网络原因你会遇到

*GPG key retrieval failed: [Errno 12] Timeout on https://download.docker.com/linux/centos/gpg: (28, ‘Operation timed out after 30010 milliseconds with 0 out of 0 bytes received’)*

这样的错误，可将/etc/yum.repos.d/docker-ce.repo里面的

<https://download.docker.com/linux/centos>

全局替换成

<https://mirrors.ustc.edu.cn/docker-ce/linux/centos>

```shell
[root@localhost ~]# vi /etc/yum.repos.d/docker-ce.repo 
:%s/https:\/\/download.docker.com\/linux\/centos/https:\/\/mirrors.ustc.edu.cn\/docker-ce\/linux\/centos/g
[root@localhost ~]# yum install docker-ce ##安装docker
[root@localhost ~]# systemctl start docker ##启动docker
[root@localhost ~]# systemctl status docker ##查看启动状态
```

### 配置阿里云镜像加速器

访问网址<https://cr.console.aliyun.com/cn-qingdao/mirrors>

账号登陆即可拥有你的镜像加速器地址

```shell
vi /etc/docker/daemon.json
添加如下内容
{
  "registry-mirrors": ["您的镜像加速器地址"]
}
```

