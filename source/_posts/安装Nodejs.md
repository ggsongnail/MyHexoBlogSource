---
title: 安装Nodejs
date: 2018-06-23 11:38:56
tags: 前端
---

### 1.下载nodejs并安装

### 2.设置全局路径

```shell
npm config set prefix  "E:\nodejs"
```

这样下次用npm install -g 全局安装时会把包安装到此目录下

### 3.查看设置是否生效

```shell
npm config get prefix
```

### 4.安装taobao NPM镜像

```shell
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

因为第2步已把全局路径改成了"E:\nodejs"，所以cnpm会被安装到这个路径下

### 5.配置cnpm环境变量

将"E:\nodejs"配置到windows的环境变量中

### 6.安装成功

```
C:\Users\Administrator>cnpm -version
cnpm@6.0.0 (E:\nodejs\node_modules\cnpm\lib\parse_argv.js)
npm@6.1.0 (E:\nodejs\node_modules\cnpm\node_modules\npm\lib\npm.js)
node@8.11.2 (C:\Program Files\nodejs\node.exe)
npminstall@3.6.2 (E:\nodejs\node_modules\cnpm\node_modules\npminstall\lib\index.js)
prefix=E:\nodejs
win32 x64 10.0.14393
registry=https://registry.npm.taobao.org
```

