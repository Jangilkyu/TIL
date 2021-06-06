## **학습 목표**

기본형 타입(primitive type)이 메모리에 선언되고 할당되는 과정을 알아보자.

## **학습 내용**
- [공부할 코드](#공부할-코드)
- [전처리과정](#전처리과정)
- [i 변수 공간 할당](#i-변수-공간-할당)
- [i 변수 초기화](#i-변수-초기화)
- [double d 선언과 동시에 초기화](#double-d-선언과-동시에-초기화)
- [main()메소드 종료](#main()메소드-종료)
- [reference](#reference)

## **공부할 코드**

- 정수형 타입인 int 타입에 i 변수를 정의하였다.
- i에 10이라는 리터럴 값을 대입하였다.
- 실수형 타입 double 타입에 d 변수를 정의함과 동시에 7.14 값으로 초기화 하였다.

❓ 해당 변수들이 stack 영역인 stack frame안에 어떻게 공간이 차지하는지 공부해 보고자 합니다.

```java
package com;

public class Hello {
    public static void main(String[] args) {
        int i;
        i = 10;

        double d = 7.14;
    }
}
```

## **전처리과정**

이전 시간에 학습했던 JRE가 JVM을 부팅한 후 JVM이 Java Memory 구조인 Runtime Data Area를 만들어 클래스 영역에 java.lang패키지와 여러 클래스들을 로딩하고 stack 영역에 main()메소드를 배치한 후 stack프래임을 생성한 후 메소드 인자들을 위한 변수 공간까지 만드는 것은 동일하다.

![image](https://user-images.githubusercontent.com/69107255/120889521-8498b280-c638-11eb-9048-4dea300f21db.png)


## **i 변수 공간 할당**

![image](https://user-images.githubusercontent.com/69107255/120889472-561ad780-c638-11eb-94ee-23547e0c0398.png)


main()메소드가 실행되고 `int i;`라는 구문을 실행한다.<br>
JVM은 stack Area인 Stack Frame안에 int i;를 4byte 크기의 정수 저장공간을 할당한다.<br>
이 때 변수 i는 선언만 했기 때문에 쓰레기 값이 들어가 있다.

### **❓ 변수를 선언만 하고 초기하지않은 상태에서 사용하면 어떻게 될까?**

javac 컴파일러는 i 변수는 초기화가 되지 않았을 수도 있다고 컴파일러(javac)는 컴파일 에러로 개발자에 코드에 잘못된 점을 지적해준다.

![image](https://user-images.githubusercontent.com/69107255/120889165-d4767a00-c636-11eb-87df-93d630608891.png)


## **i 변수 초기화**

```java
    i = 10;
```
i 변수에 10을 할당함으로써, stack frame에 i는 10이라는 값을 가지게 된다.

![image](https://user-images.githubusercontent.com/69107255/120889325-7b5b1600-c637-11eb-922d-6436742c5e52.png)


## **double d 선언과 동시에 초기화**

실수형 타입인 d변수에 선언과 동시에 초기화를 하는 과정에 stack frame이다.
이 때는 바로 d변수를 바로 사용할 수 있게 된다.

![image](https://user-images.githubusercontent.com/69107255/120889451-37b4dc00-c638-11eb-9883-aa3e321664a1.png)

## **main()메소드 종료**

main()메소드의 `닫는 중괄호 }`를 만나는 순간 stack frame은 소멸되고 stack영역은 종료된다. 즉, 프로그램이 종료가 된다.

![image](https://user-images.githubusercontent.com/69107255/120889540-a85bf880-c638-11eb-9805-8b1167aeabbb.png)

---
## **reference**

- 도서
    - 스프링 입문을 위한 자바 객체 지향의 원리와 이해

02장 자바와 절차적/구조적 프로그래밍 - 변수와 메모리: 변수! 너 어디있니?