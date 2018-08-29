---
title: JAVA强引用和弱引用以及软引用
date: 2018-08-29 21:09:32
tags: JAVA
---

对于JAVA的OOM（OutOfMemory）大家并不陌生，为了避免它，JAVA提供了强引用、软引用、软引用这三个引用类型来针对避免OOM时所采取相应的回收策略

### 强引用

强引用一般用的最多，例如

```java
Car car = new Car();
String name = "Jony"；
```

这类型的引用，只要car、name的引用变量不被set null时，jvm都不会回收这样的对象

### 弱引用

弱引用用于那些非必须对象，不管内存充不充足，JVM进行垃圾回收时都会回收弱引用引用的对象

```java
public class TestWeakReference {
    public static void main(String[] args) {
        Car car = new Car();
        car.setName("凯迪拉克");
        WeakReference<Car> weakReference = new WeakReference(new Car());
        System.out.println("强引用："+car);
        System.out.println("弱引用："+weakReference.get());
        System.gc();
        System.out.println("JVM回收后强引用："+car);
        System.out.println("JVM回收后弱引用："+weakReference.get());
    }
}
```

> 输出
>
> 强引用：com.example.demo.entry.Car@3cd1a2f1
> 弱引用：com.example.demo.entry.Car@2f0e140b
> JVM回收后强引用：com.example.demo.entry.Car@3cd1a2f1
> JVM回收后弱引用：null

但是看看下面这个

```
public class TestWeakReference {
    public static void main(String[] args) {
        Car car = new Car();
        car.setName("凯迪拉克");
        //WeakReference<Car> weakReference = new WeakReference(new Car());
        WeakReference<Car> weakReference = new WeakReference(car);
        System.out.println("强引用："+car);
        System.out.println("弱引用："+weakReference.get());
        System.gc();
        System.out.println("JVM回收后强引用："+car);
        System.out.println("JVM回收后弱引用："+weakReference.get());
    }
}
```

> 输出
>
> 强引用：com.example.demo.entry.Car@3cd1a2f1
> 弱引用：com.example.demo.entry.Car@3cd1a2f1
> JVM回收后强引用：com.example.demo.entry.Car@3cd1a2f1
> JVM回收后弱引用：com.example.demo.entry.Car@3cd1a2f1

JVM垃圾回收后，弱引用所引用的对象因为是一个Car对象的强引用，所以不会被回收

### 软引用

这种类型的引用最大的特点就是，只有当内存不足的时候，JVM垃圾回收才会回收该对象，并且常与引用队列(ReferenceQueue)来使用，当软引用对象被回收时，软引用变量会被记录到ReferenceQueue中

为了实现JVM内存不足我们用下代码

```java
private static void simulateOOME() { //模拟OOME
        try {
            final ArrayList<Object[]> allocations = new ArrayList<Object[]>();
            int size;
            while ((size = Math.min(Math.abs((int) getRuntime().freeMemory()), Integer.MAX_VALUE))>0){
                allocations.add(new Object[size]);
            }
        } catch (OutOfMemoryError e) {
        }
    }
```

```java
 public static void main(String[] args) {
        ReferenceQueue referenceQueue = new ReferenceQueue();
        Car car = new Car(); //强引用
        car.setName("凯迪拉克");
        car.setType(1);
        SoftReference<Car> softReference = new SoftReference<>(car,referenceQueue);//软引用
        System.out.println(softReference.get().getName());
        car = null;
        System.out.println(softReference.get().getName());
        System.out.println(referenceQueue.poll());
        simulateOOME(); //模拟oome
        System.out.println(softReference.get()); //软引用的对象会在oome之前被回收
        System.out.println(referenceQueue.poll()); //回收对象的同时软引用会被记录在referenceQueue里

    }
```

