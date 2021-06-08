## 목표

열거형에 대해서 학습해보자.

## 학습 내용
- [enum이란?](#enum이란?)
- [enum 정의하는 방법](#enum-정의하는-방법)
- [enum이 제공하는 메소드](#enum이-제공하는-메소드)

![image](https://user-images.githubusercontent.com/69107255/121130988-1e937180-c86a-11eb-905c-dbff227f8370.png)

[그림 참조](https://kingpodo.tistory.com/54)

**열거 타입**은 `참조 타입`이다.

## enum이란?

- enum이란 enumerated type 열거형이라고 부른다.
- 서로 연관되어 있는 상수들의 집합니다.
- 기존에 상수를 사용하면서 발생했던 문제(typesafe)를 개선하기 위하여 jdk1.5부터 추가 된 기능이다.

```
    Enumerated type : 열거형 타입
```

이전에는 `public static final`을 통하여 문자를 정수 타입을 정의하였다.

- 정수 열거 타입 사용법
```java
    public class Month {
        public static final int JANUARY= 1;
        public static final int FEBRURARY = 2;
        public static final int MARCH = 3;

        public static final int ONE = 0;
        public static final int TWO = 0;
        public static final int THREE = 0;

        public static void main(String[] args) {
            System.out.println(Month.JANUARY == Month.ONE); // true   
        }
    }
```
하지만 정수 열거 타입에는 단점들이 있다.<br>
- 타입에 안전하지 않다.
    - 상수 값이 변경된다면 컴파일을 다시 해야한다. 컴파일을 하지 않을 시 해당 클래스를 사용하는 클래스는 잘못된 값으로 동작할 가능성이 있다.
- 의미 있는 문자열 출력이 어렵다.
    - 정수 열거 타입에서 정의한 상수를 출력하게 되면 숫자로 출력이 된다. 상수의 의미를 알기가 어렵다. 위에 Month코드에서 JANUARY와 ONE의 상수를 비교 시 값은 같지만 실제 의미는 다르다.

## enum 정의하는 방법

```java
    public enum 열거타입이름 { 열거타입상수들 .... }

    public enum Month{
        JANUARY,
        FEBRURARY,
        MARCH
    }

```

- 열거 타입 선언
    - 열거 타입 상수는 대문자로 작성한다. 단어 연결 시 `_`로 연결한다.
- 열거 타입 변수
    - 열거 타입 변수는 참조 타입이기 때문에 `null`을 저장할 수 있다.

- 열거형 상수 비교에는 `==`과 `compareTo()`로 비교 할 수 있다.

## enum이 제공하는 메소드

- values() 메소드
    - 열거형의 모든 상수를 배열에 담은 후 반환한다.
    - 모든 열거형이 가지고 있고 컴파일러가 자동으로 추가해준다.

- valueOf()
    - 열거형 상수의 이름을 통하여 문자열 상수에 대한 참조를 얻는다.
    ```java
        Month m = Month.valueOf("JANUARY");
        System.out.println(m); // JANUARY
    ```


---
- 남궁성. Java의 정석 3판. 도우출판, 2016.
- (int 상수 대신 열거 타입을 사용하라)[https://javabom.tistory.com/48]