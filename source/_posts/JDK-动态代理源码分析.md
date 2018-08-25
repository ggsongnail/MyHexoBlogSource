---
title: JDK 动态代理源码分析
date: 2018-08-25 20:28:04
tags: JAVA
---



在Java中如果要你对某个类的某个方法进行增强(就好比你唱歌的时候给你来点伴奏)你会怎么做？比如对下面这个StarSinger的方法进行伴奏加强

```java
public class StarSinger {
    public void sing(){
        System.out.println("动情歌唱一曲");
    }
}
```

### Round One

程序员表示我会用一个类来包装增强

```java
public class EnhanceSinger {
    public void enhanceStarSing(){
        StarSinger starSinger = new StarSinger();
        System.out.println("爵士鼓+吉他伴奏");
        starSinger.sing();
        System.out.println("观众掌声");
    }
}
```

到目前为止好像没毛病，但是现在教师、学生、程序员等各行各业的灵魂歌者也要在唱歌的时候来点伴奏咋办？程序员表示可以继续在EnhanceSinger类里对这些歌唱者进行伴奏

```java
public class EnhanceSinger {
    public void enhanceStarSing(){\\增强明星演唱
        StarSinger starSinger = new StarSinger();
        System.out.println("爵士鼓+吉他伴奏");
        starSinger.sing();
        System.out.println("观众掌声");
    }
    public void enhanceProgrammerSing(){\\程序员演唱
        ProgrammerSinger programmerSinger = new ProgrammerSinger();
        System.out.println("爵士鼓+吉他伴奏");
        programmerSinger.sing();
        System.out.println("观众送上了砖头");
    }
    、、、、
}
```

但是这样每多一个人演唱，就要加多一个方法实在太笨拙，因为往后要改成其他伴奏，岂不是每个增强的方法都要去修改？程序员表示压力很大，仔细思考后有了下一种方案

### Round Two

先定义一个接口

```java
public interface Singer {
    void sing();
}
```

歌唱者都继承这个接口

```java
public class StarSinger implements Singer{
    public void sing(){
        System.out.println("明星在发布会动情歌唱一曲");
    }
}
```

```java
public class ProgrammerSinger implements Singer{
    public void sing(){
        System.out.println("程序员在失恋后高歌一曲");
    }
}
```

再来一个升级版的增强类<span style="color:red">EnhanceSingerV2</span>

```java
public class EnhanceSingerV2 {
    public void enhanceSing(Singer singer){
        System.out.println("爵士鼓+吉他伴奏");
        singer.sing();
        System.out.println("观众被迫鼓掌");
    }
}
```

调用的时候可以

```java
public class TestEnhanceSingerV2 {
    public static void main(String[] args) {
        StarSinger starSinger = new StarSinger();
        ProgrammerSinger programmerSinger = new ProgrammerSinger();
        EnhanceSingerV2 enhanceSingerV2 = new EnhanceSingerV2();
        enhanceSingerV2.enhanceSing(starSinger);//明星演唱被加强
        enhanceSingerV2.enhanceSing(programmerSinger);//程序员演唱被加强
        、、、、
    }
}
```

似乎有了比较大的进步，这个方案江湖人称**静态代理**，EnhanceSingerV2这个类我们称其为代理类。现在如果要变其他伴奏只要修改EnhanceSingerV2的enhanceSing方法即可，不用像第一回合的方案那样一个一个方法去修改。

目前来看Round 2的方案比较给力了，每次要换伴奏时改一处地方便可以达到效果，这样一来就有更多的时间和妹子聊聊天了。可是天有不测风云，一天广场舞大妈说她在跳舞的时候也想来段伴奏，程序员听了这还不简单，依葫芦画瓢再定义一个接口

```java
public interface Dancer {
    void dance();
}
```

大妈去实现它

```java
public class SquareAuntDancer implements Dancer {
    public void dance(){
        System.out.println("大妈翩翩起舞");
    }
}
```

反正在**EnhanceSingerV2**代理下都有加伴奏这个功能，程序员为了偷懒不顾招牌的名字，公然把代码写在此处

```java
public class EnhanceSingerV2 {
    public void enhanceSing(Singer singer){
        System.out.println("爵士鼓+吉他伴奏");
        singer.sing();
        System.out.println("观众被迫鼓掌");
    }
    public void enhanceDance(Dancer dancer){
        System.out.println("爵士鼓+吉他伴奏");
        dancer.dance();
        System.out.println("群众被迫离场");
    }
    、、、、
}
```

```java
public class TestEnhanceSingerV2 {
    public static void main(String[] args) {
        Singer starSinger = new StarSinger();
        Singer programmerSinger = new ProgrammerSinger();
        EnhanceSingerV2 enhanceSingerV2 = new EnhanceSingerV2();
        enhanceSingerV2.enhanceSing(starSinger);
        enhanceSingerV2.enhanceSing(programmerSinger);
        //给大妈来点伴奏
        Dancer squareAuntDancer = new SquareAuntDancer();
        enhanceSingerV2.enhanceDance(squareAuntDancer);
        、、、、
    }
}
```

写完后程序员总觉的哪里不对劲，看着自己写的代码，突然菊花一紧，脑中闪道：“如果各行各业在工作时都要来点伴奏，杀猪的时候要伴奏，唱歌的离场也要伴奏，那上面的EnhanceSingerV2里的要写方法岂不是越来越多？"

```java
public class EnhanceSingerV2 {
    public void enhanceSing(Singer singer){
        System.out.println("爵士鼓+吉他伴奏");
        singer.sing();
    }
    public void enhanceDance(Dancer dancer){
        System.out.println("爵士鼓+吉他伴奏");
        dancer.dance();
    }

	//歌者离场
    public void enhanceLeave(Singer singer){
        System.out.println("爵士鼓+吉他伴奏");
        singer.leave();
    }

	//屠夫开杀
    public void enhanceKill(Butcher butcher){
        System.out.println("爵士鼓+吉他伴奏");
        butcher.kill();
    }
    、、、、
}
```

”而且改伴奏又得一条一条的改，长期以往不仅身体被掏空，搞不好更会失去陪妹子的时间，到头来又是光棍一场“。程序员想了想，虽然可以将

```
System.out.println("爵士鼓+吉他伴奏");
```

抽成公用的方法，但也无法避免EnhanceSingerV2越来越臃肿（<span style="color:red">比如Singer的其他方法要伴奏，或者其他新的类的方法要加伴奏都要维护这个类的代码，上面的歌者离场和屠夫开杀就是这样的情况</span>）

### Round Three

使用JDK动态代理

自定义InvocationHadler

```java
public class MyInvocationHandler implements InvocationHandler {
    private Object object;

    public void setObject(Object object) {
        this.object = object;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("爵士鼓+吉他伴奏");
        return method.invoke(object,args);
    }

```

利用JDK生成的代理类

```java
public class TestJdkProxy {
    public static void main(String[] args) {
        MyInvocationHandler myInvocationHandler = new MyInvocationHandler();
        Butcher pigButcher = new PigButcher();
        Singer programmerSinger = new ProgrammerSinger();
        Singer starSinger = new StarSinger();
        Dancer squareAuntDancer = new SquareAuntDancer();
        List<Object> objects = Arrays.asList(pigButcher,programmerSinger,starSinger,squareAuntDancer);
        objects.forEach(v->{
            myInvocationHandler.setObject(v);
            Object clz = Proxy.newProxyInstance(v.getClass().getInterfaces()[0].getClassLoader(),v.getClass().getInterfaces(),myInvocationHandler);
            Arrays.asList(clz.getClass().getDeclaredMethods()).forEach(m->{
                try {
                    if(m.getReturnType().getName().equals("void")){
                        m.invoke(clz,null);
                        System.out.println("===============华丽的分割线==============");
                    }
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                } catch (InvocationTargetException e) {
                    e.printStackTrace();
                }
            });
        });
    }
```