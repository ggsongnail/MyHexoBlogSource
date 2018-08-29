---
title: JDk动态代理源码解析
date: 2018-08-26 22:16:15
tags: JAVA
---

如果你很好奇JDK动态代理如何生成代理类的，请跟我走一遍吧。

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

动态代理类(proxyClass)是在运行期间被创建的，想了解其创建过程首先我们来看Proxy的newProxyInstance方法

我这里抽出这个方法关键的几个地方便于了解

> **关键1：**`Class<?> cl = getProxyClass0(loader, intfs);`
>
> 这个方法是查找或者创建指定的代理类用的，这里的指定则是通过loader, intfs来决定的。这个方法里面主要用到了一个方法`proxyClassCache.get(loader, interfaces)；`
>
> proxyClassCache我们来看下是个啥？
>
> ```java
> private static final WeakCache<ClassLoader, Class<?>[], Class<?>>
>     proxyClassCache = new WeakCache<>(new KeyFactory(), new ProxyClassFactory());
> ```
>
> 看得出这个proxyClassCache是使用WeakCache的构造函数并传入KeyFactory和ProxyClassFactory对象参数的构造的对象 ，有点绕口，不知道干嘛用的咱也不理，先去看看proxyClassCache的get方法
>
> ```
> final class WeakCache<K, P, V> {
>     public V get(K key, P parameter){
> 		//这个方法其实可以字面翻译为‘擦除掉旧的Entrys’；进入可以看到里面有个CacheKey<K> 				//cacheKey对象，这个对象其实就是弱引用的实现，是一个classloader的弱引用。JVM在回收弱
> 		//引用对象时，顺便把这个弱引用变量记录到一个引用队列refQueue里，以这个作为key，将 			//ConcurrentMap<Object, ConcurrentMap<Object, Supplier<V>>> map中的value取出
> 		//再拿这个value 到ConcurrentMap<Supplier<V>, Boolean> reverseMap 作为key 删除
> 		//这个key对应的数据
> 		expungeStaleEntries();
> 		
> 		//结合引用队列创建代理接口的classloader的弱引用
> 		Object cacheKey = CacheKey.valueOf(key, refQueue);
> 		
> 		
>     }
> }
> ```
>
>





