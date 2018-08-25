---
title: 如何在github写博客
date: 2018-06-03 14:39:17
tags: Life
---

这是windows下的教程

### 一、安装Git，Nodejs

Git默认安装即可使用，Nodejs相关请参考

https://gg.songnail.com/2018/06/23/%E5%AE%89%E8%A3%85Nodejs/

### 二、安装Hexo

官网链接：https://hexo.io/

```shell
npm install hexo-cli -g ##全局安装hexo
hexo init blog ##创建一个blog
cd blog
npm install ##安装hexo所需组件
hexo server ##启动hexo
```

上面几个步骤执行完，在浏览器打开<http://localhost:4000/> （具体端口看你的控制台）便可预览你生成的博客

### 三、配置GithubPage

#### 1.注册一个Github账号

#### 2.New Repository

repository name要以.github.io结尾：比如songgnim.github.io这样的命名

#### 3.Repository Settings

主要是配置你的Source为master branch 和 配置你的Custom domain（这里需要你有个域名）

![1529728153994](如何在github上写博客\1529728153994.png)

#### 4.域名解析

记录类型：CNAME

主机记录：XX（随意命名）

记录值：songgnim.github.io（你的repository名字）

如![1529728073411](如何在github上写博客\1529728073411.png)



### 四、Hexo关联Github Page

#### 1.设置Git的user name 和 email

``` shell
git config --global user.name "ggsongnail"
git config --global user.email "ggsongnail@gmail.com"
```

#### 2.生成新的SSH key 然后添加到 ssh-agent

- ##### a.打开Git Bash

- ##### b.运行下面的语句，账号替换成你的Github 邮箱地址，会生成一个新的ssh key

  ```shell
  ssh-keygen -t rsa -b 4096 -C "ggsongnail@gmail.com"
  ```

- ##### c.命令执行后会得到这个提示

  ```shell
  Enter a file in which to save the key (/c/Users/you/.ssh/id_rsa):[Press enter]
  Enter passphrase (empty for no passphrase): [Type a passphrase]
  Enter same passphrase again: [Type passphrase again]
  ```

  默认按enter，将会把 public/private key生成到默认的路径C:\Users\Administrator\\.ssh

  继续按enter，默认不用密码

- ##### d.把SSH key添加到 ssh-agent

  ```shell
  # start the ssh-agent in the background
  eval $(ssh-agent -s)
  Agent pid 59566
  ```

  ```shell
  ssh-add ~/.ssh/id_rsa
  ```

- ##### e. [把SSH key添加到 GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)

#### 3.在Hexo的 _config.yml文件配置Deployment

```yaml
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git
  repo: git@github.com:ggsongnail/songgnim.github.io.git
  branch: master
```

使用

```shell
hexo d -g ##把生成的博客发布到github
```

### 五、写博客

完成上述的4大操作基本可以搭出个个人的博客了，最后都是在使用MarkDown的标准特性和hexo的基本命令去写博客

- 编写markdown文件我目前使用的是Typora这个工具

- 博客里插入图片需要做如下几个操作

  ```embeddedjs
  1 把主页配置文件_config.yml 里的post_asset_folder:这个选项设置为true
  
  2 在你的hexo目录下执行这样一句话npm install hexo-asset-image --save，这是下载安装一个可以上传本地图片的插件
  
  3 等待一小段时间后，再运行hexo n "xxxx"来生成md博文时，/source/_posts文件夹内除了xxxx.md文件还有一个同名的文件夹
  ```

- 主题可以去官网找

