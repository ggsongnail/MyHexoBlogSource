---
title: Spring AOP
date: 2018-07-19 20:42:25
tags: Spring
---

### 一、AOP（Aspect Oriented Programming）面向切面编程

在软件开发中，例如日志、安全和事务管理这些会分布于应用中的多处地方，而这些可能多次重复使用的功能我们称之为**横切关注点**，将这些横切关注点与业务逻辑分离正是面向切面编程（AOP）所要解决的

### 二、AOP优点

在解决横切关注点这个问题的方法中，继承和委托（依赖、关联、组合、聚合）是最常见的面向对象技术。但是如果在整个应用中使用相同的基类，继承往往会导致一个脆弱的对象体系，因为其打破了面向对象的封装性，超类更改、新增方法导致子类无法正常执行或编译错误。委托则可能需要对委托的对象进行复杂的调用。AOP则将关注点只集中一处并且转移到切面中，服务模块（主业务）会因为针对性强而更简洁

### 三、AOP术语

- **通知（Advice）**  

定义了切面何时使用，并且描述了切面要完成的工作

*Before*：在方法被调用之前调用通知

*After*：在方法完成之后调用通知

*After-returning*：在方法执行完成之后调用通知

*After-throwing*：在方法抛出异常之后调用通知

*Around*：在方法调用之前和调用之后调用通知

- **连接点（Joinpoint）**

它是应用在执行过程中能够插入切面的一个点，这个点可以是调用方法时、抛出异常时、甚至修改一个字段时。切面代码可以在这些点插入到应用的正常流程中

- **切点（Pointcut）**

通知定义了**什么**，连接点定义了**何时**，那么切点就是用来定义**何处**的。切点定义通知所要织入的一个或多个连接点。我们通常使用明确的类和方法名称来指定这些切点，或者用正则表达式来匹配类和方法名来指定这些切点

- **切面（Aspect）**

切面是通知和切点的结合，通过连接点共同定义了切面的全部内容--它是什么，在何时何处完成其功能

- **引入（Introduction）**

引入允许我们对现有的类添加新的方法和属性。例如一个Fish（只有class文件）的类，它没有一个fly()的方法，我们可以创建一个Bird的通知类，该类定义了一个fly()的方法，通过切面配置我们可以将fly()的方法引入到Fish的类中，我们无需修改现有的类，就可以让鱼有了飞翔的方法。

```java
@Aspect
public class BirdAspect {
	@DeclareParents(
		value="com.animal.Fish",
		defaultImpl=Bird.class
	)
	public static IBird birdFish;
}
```

```java
public interface IBird {
    void fly();
}
public class Bird {
    public void fly(){
        System.out.println("我可以让鱼飞翔");
    }
}
```

```java
@Bird
public class Fish {
    
}
```

```java
@Autowired
private Fish fish; //实际上是 IBird fish = (IBird) ctx.getBean("fish",Fish.class);
public void fishFly(){
    fish.fly();
}
```

- **织入（Weaving）**

织入是将切面应用到目标对象来**创建新的代理对象**的过程。切面在指定的连接点被织入到目标对象。在目标对象的生命周期里有多个点（不同于连接点）可以进行织入

**编译期：**切面在目标类编译时被织入。这种方式需要特殊的编译器。AspectJ的织入编译器就是以这种方式织入切面的。

**类加载期：**切面在目标类加载到JVM时被织入。这种方式需要特殊的类加载器（ClassLoader），它可以在目标类被应用引用前增强该目标类的字节码，AspectJ 5的LTW（load-time weaving）就支持这种方式织入切面

**运行期：**切面在应用运行的某个时刻被织入，在织入切面时，AOP容器会为目标对象动态的创建一个代理对象。Spring AOP就是以这种方式织入切面的

```
编译期、类加载期、运行期分别对应Java源文件、.class文件、内存中的字节码。我们在使用注解的时候经常也要定义@Retention(RetentionPolicy.RUNTIME)类似这样的注解，具体含义：
RetentionPolicy.SOURCE:注解只保留在源文件，当Java文件编译成class文件的时候被遗弃
RetentionPolicy.CLASS：注解只保留到class文件，当jvm加载class文件的时候被遗弃
RetentionPolicy.RUNTIME：整个生命周期都存在
怎样选择注解适合的生命周期？
如果需要在应用中动态获取数据、注解信息的，最好用RUNTIME。
如果需要在编译时进行一些预处理操作比如增强目标类代码，最好用CLASS
如果只是做一些检查性的操作，比如@Override和@SuppresWarnings,则可以使用SOURCE注解
```



### 四、

