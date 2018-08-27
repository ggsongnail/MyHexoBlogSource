---
title: JAVA注解剖析
date: 2018-08-27 19:50:14
tags: JAVA
---

**创建一个作用类的注解@Target(ElementType.<span style="color:red">TYPE</span>)**

**并且保留至运行期间@Retention(RetentionPolicy.RUNTIME)**

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface Foo {
    String value() default "FOO";
}
```

**创建一个作用于类方法的注解@Target(ElementType.<span style="color:red">METHOD</span>)**

**并且保留至运行期间@Retention(RetentionPolicy.RUNTIME)**

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface FooMethod {
    String value();
}
```

**上面就生成了两个注解，我们来使用它们**

```java
@Foo
public class TestAnnotation {
    public static void main(String[] args) throws NoSuchMethodException {
        Class<?> clz = TestAnnotation.class;
        //获取注解的value
        System.out.println(clz.getDeclaredAnnotation(Foo.class).value());
        System.out.println(clz.getDeclaredMethod("foo",null)
                           .getDeclaredAnnotation(FooMethod.class).value());
    }
    @FooMethod("foo")
    public void foo(){

    }
}
```

**输出结果：**

> FOO
> foo

**底层原理：**

注解在编译时，编译器会将注解的内容附加到使用的类的class结构中，因为class文件结构在jvm规范中是严格有序的格式，只有class的attributes属性才能添加注解信息。所以编译器会把上面TestAnnotation的@Foo注解放在类属性里、@FooMethod("foo")放在方法属性里。从上面获取value的方法便可看出。

我们再来用下面的命令查看下编译器生成的TestAnnotation.class文件

`javap -v  TestAnnotation.class > test.txt`

打开生成的test.txt，文件有点长，找到**RuntimeVisibleAnnotations** 属性，每个使用注解的类都有此属性，此属性会在jvm加载字节码的时候被加入到Class对象中。所以才可通过`clz.getDeclaredAnnotation(Foo.class)`这个方法来获取到注解的内容。

`clz.getDeclaredAnnotation(Foo.class)`这个方法我们debug进去看看，

![C:\Users\ggson\Documents\Hexo\source\_posts\JAVA注解剖析](C:\Users\ggson\Documents\Hexo\source\_posts\JAVA注解剖析\debug.PNG)

没错这个获取到的注解对象是个动态代理生成的代理对象来的。再用 `clz.getDeclaredAnnotation(Foo.class).getClass().getInterfaces()`这个方法看看这个对象实现的接口是`interface com.example.demo.annocation.Foo`。最后值得一提的是，RuntimeVisibleAnnotations属性是在动态代理生成这个对象的时候设置到这个代理对象中的。