## **목표**

Hello.java를 JVM으로 실행해보기

## **학습 내용**
- [JVM이란?](#JVM이란?)
- [컴파일 과정](#컴파일-과정)
    - [1. 소스코드 작성](#1.-소스코드-작성)
    - [2. 저장 된 소스코드 확인](#2.-저장-된-소스코드-확인)
    - [3. Hello.java 컴파일](#3.-Hello.java-컴파일)
    - [javac 옵션](#javac-옵션)
    - [4. Hello.java 실행 결과](#4.-Hello.java-실행-결과)
- [JVM Meomry 구조](#JVM-Meomry-구조)
    - [Runtime Data Area](#Runtime-Data-Area)

# **JVM이란?**

JVM은 Java Virtual Marchine의 줄임말입니다. Java Byte Code를 OS(Windows, Mac, Linux)에 종속적이지 않게 Java Program을 실행해 주는 역할을 하는 프로그램입니다.<br>
<br>

![image](https://user-images.githubusercontent.com/69107255/120779943-91e36d80-c562-11eb-82f2-060918e3cfc2.png)

위에 그림과 같이 Write once, run anywhere(한 번 작성하면 어디서든 실행된다.)<br>


# **컴파일 과정**

통합 개발 환경(IDE : Integrated Development Environment)을 통하여 손쉽게 컴파일,디버깅,배포 등 프로그램 개발에 관련된 작업을 eclipse나 intellij를 사용하여 개발을 할 수 있지만 메모장(Note pad)이나 리눅스(Linux)환경에서도 소스코드를 컴파일 후 실행 할 수 있다.

## **1. 소스코드 작성**

![image](https://user-images.githubusercontent.com/69107255/120806911-5e184000-c582-11eb-9544-b209fafd759a.png)

터미널 리눅스(Linux) 환경에서 `Hello.java` 소스코드를 작성하였다.

## **2. 저장 된 소스코드 확인**

![image](https://user-images.githubusercontent.com/69107255/120807622-1d6cf680-c583-11eb-97e2-ea9ee6bd5433.png)

`ls -l` 명령어를 통해 정상적으로 소스코드 파일이 만들어졌는지 확인해봤다.

## **3. Hello.java 컴파일**

- 사람이 알아볼 수 있는 언어를 컴퓨터의 언어로 번역한다.
- `javac.exe`를 통해 컴파일을 수행
- 정상적으로 compile이 완료가 되면 bytecode생성 👉 파일명.class

![image](https://user-images.githubusercontent.com/69107255/120808014-92d8c700-c583-11eb-96dc-2296f5358a8b.png)

```
javac 클래스명.java
```
위에 명령어를 통하여 `Hello.java`파일을 -> `Hello.class`파일로 변환시켜주는 명령어이다.

### **javac 옵션**

|옵션|설명|예제|
|:----|:----|:----|
|-classpath<br> -cp | 컴파일 시 참조(실행) 할 클래스 파일의 경로를 지정|javac -classpath "ilkyu/Desktop/Hello.java"<br>javac -cp "/ilkyu/Desktop/Hello.java"|
|-d	| 클래스파일을 생성할 root Directory 설정.|javac -d "/ilkyu/Desktop/path"|
|-sourcepath | 소스파일 위치를 지정|javac -sourcepath "/ilkyu/Desktop/path"|
|-encoding|소스 파일에 사용된 인코딩을 지정|javac -encoding "uft-8" Hello.java|
|-g | 디버깅 정보를 출력|javac -g|


## **4. Hello.java 실행 결과**

- `java.exe`실행 시 JVM이 생성된다.<br>
- JVM이 실행되고 class가 적재(load)되어 클래스에 내용이 실행된다.

![image](https://user-images.githubusercontent.com/69107255/120814281-b1da5780-c589-11eb-84a6-df1a0d36a34b.png)

```java
java bytecode명
```

# **JVM Meomry 구조**

![image](https://user-images.githubusercontent.com/69107255/120820580-a427d080-c58f-11eb-9562-25cb261b4c80.png)

## Runtime Data Area

- Garbage Collector
    - Heap 메모리 영영에 생성 된 객체들중에 Reachability를 잃은 객체를 탐색 후 제거하는 역할을 한다.

- class(Method) Area
    - class의 멤버 변수와 멤버 함수와 Type(Class 및 interface)정보, static, final 변수등이 생성된다.

- Heap Area
    - 인스턴스가 생성되는 공간이다.
    - new 키워드로 생성된 객체나 배열을 저장하는 공간이다.

- Stack Area
    - LIFO(Last In First Out) 나중에 들어온 것이 먼저 나가는 구조
    - 지역변수나 파라미터 등이 생성되는 영역이다.
- PC Resiter
    - 프로그램 수행을 위해서 OS에서 할당 받은 메모리 공간이다.
- Native Method Stack
    - class file을 읽고 분석 후 class 정보를 저장하는 공간이다.
    - 자바외 언어로 작성된 Native code를 위한 메모리 영역이다.
- `native` keyword는 java 프로그램에서 다른 언어(C, C++, 어셈블리 등으로 작성된 코드를 실행할 수 있는 JNI(Java Native Interface) 키워드이다.

---
## **Reference**
이미지는 ppt로 제작<br>
[javac 명령어 모음](https://team621.tistory.com/38)<br>
[JVM 구조](https://velog.io/@litien/JVM-%EA%B5%AC%EC%A1%B0)