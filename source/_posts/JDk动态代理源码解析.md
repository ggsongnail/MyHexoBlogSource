---
title: JDk动态代理源码解析
date: 2018-08-26 22:16:15
tags: JAVA
---

平时我们如果要为某个接口(下面的Foo)创建代理我们可以这样

```java
InvocationHandler handler = new MyInvocationHandler(...);
Class<?> proxyClass = Proxy.getProxyClass(Foo.class.getClassLoader(), Foo.class);
Foo f = (Foo) proxyClass.getConstructor(InvocationHandler.class).
                newInstance(handler);
```

或者更简单点

```java
Foo f = (Foo) Proxy.newProxyInstance(Foo.class.getClassLoader(),
                                     new Class<?>[] { Foo.class },
                                     handler);
```

动态代理类(proxyClass)实在运行期间被创建的，想了解其创建过程首先我们来看Proxy的newProxyInstance方法

我这里抽出这个方法关键的几个地方便于了解

> 关键1：Class<?> cl = getProxyClass0(loader, intfs);
>
> 这个方法是查找或者创建指定的代理类用的，这里的指定则是通过loader, intfs来决定的。



