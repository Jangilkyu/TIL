# **@FunctionalInterface**

함수형 인터페이스는 추상메소드 1개만 가지고 있는 인터페이스이다.

Java8부터 인터페이스에 구현체를 포함한 디폴트 메소드를 포함할 수 있다.

N개의 디폴트 메소드를 가지고 있더라도 추상 메소드는 1개만 가지고 있으면 함수형 인터페이스이다.

## FunctionalInterface 사용자 정의

```java
    @FunctionalInterface
    public interface RunFuncInterface {
        
        // 추상 메소드(abstract method)는 오직 하나여야 한다.
        T useMethod();

        static void printStatic() {
            System.out.println("static");
        }

        default void printDefault() {
            System.out.println("Default");
        }

    }
```

`static void`와 `default void`는 여러개가 있어도 에러가 발생하지 않는다.

하지만 추상 메소드가 1개 이상일 경우 @FunctionalInterface이 에러를 발생한다.

![image](https://user-images.githubusercontent.com/69107255/126489168-0443d41e-aa78-4fd5-818f-198f1dc32e56.png)


## 사용법

Java8 이전에는 익명 클래스를 이용하여 작성하였지만 Java8이후에는 람다를 통해서 코드를 줄일 수 있다.

```java
        // Java8 이전에는 익명클래스로 작성
        RunFuncInterface runFuncInterface = new RunFuncInterface() {
            @Override
            public void useMethod() {
                System.out.println("Hello, World");
            }
        };

        // Java8 이후  람다 형태에 표현식
        RunFuncInterface runFuncInterface1 = () -> System.out.println("Hello World");

        //runFuncInterface1의 useMethod() 구현체 출력
        runFuncInterface1.useMethod(); // 결과 값: Hello World

        RunFuncInterface.printStatic(); // 결과 값: static 
        runFuncInterface1.printDefault(); // 결과 값: Default
```