## 목표
이전에 학습 했던 JVM(Java Memory 구조)에서 Runtime Data Area에 클래스(class)영역과,스택(stack)영역, 힙(heap)영역에 변화에 대해서 살펴보자.

## 학습 내용

- [메서드 스택 프레임](#메서드-스택-프레임)
    - [java.lang패키지 배치](#java.lang패키지-배치)
    - [사용자가 정의한 모든 클래스 및 import 패키지 배치](#사용자가-정의한-모든-클래스-및-import-패키지-배치)
    - [stack 영영 할당](#stack-영영-할당)
    - [출력](#출력)
- [reference](#reference)

# **메서드 스택 프레임**

```java
    package com;

    public class Hello {
        public static void main(String[] args) {
            System.out.println("Hello World");
        }
    }
```

위 와 같은 Hello.java 소스파일이 있다고 해보자. main()메소드는 프로그램이 실행되는 시작점이다.
main()가 실행되면서 이전 시간에 공부를 했던 JVM에서 Runtime Data Area에 변화에 대해서 자세히 공부해보고자 합니다.

## java.lang패키지 배치

- java.lang패키지를 static Area에 배치 - main()메소드 실행 준비 1단계

![image](https://user-images.githubusercontent.com/69107255/120886700-31b7fe80-c62a-11eb-81dd-fb660c5ff711.png)

1. JRE는 Hello class에서 main()메소드가 있는지 확인이 된다면 JRE는 프로그램 실행을 위하여 JVM에 전원을 넣어 부팅한다.
2. JVM이 목적 파일(.class파일)을 받아 파일을 실행한다.
3. JVM은 전처리 과정을 진행한다.
- java프로그램에는 반드시 포함해야하는 패키지가 있습니다. `java.lang패키지`입니다. 해당 패키지를 스태틱 영역에 배치합니다.
- java.lang패키지를 main()메소드가 실행되기 전에 배치되기 때문에 `System.out.println()`메소드를 사용하여 Hello,World를 출력할 수 있게 됩니다.

## 사용자가 정의한 모든 클래스 및 import 패키지 배치

- 사용자가 정의한 class와 import package를 static Area에 배치 - main()메소드 실행 준비 2단계

![image](https://user-images.githubusercontent.com/69107255/120887217-85c3e280-c62c-11eb-89ce-f5bae2164891.png)

1. 전처리과정이 끝났습니다.


### **❓ 이제 Hello World가 출력이 될까??**
- 💁🏻‍♀️전처리 작업이 끝났다고 해서 System.out.println("Hello World");구문이 출력이 되지는 않습니다.
- Hello World가 출력되기 위해서는 main()메소드에 stack영역이 할당이 되어야합니다.
- 메소드에 여는 중괄호{ 를 만나면 stack frame이 하나씩 생깁니다.
- 따라서 위에 main()메소드 또한 stack frame으로 볼 수 있습니다.

![image](https://user-images.githubusercontent.com/69107255/120887389-78f3be80-c62d-11eb-881b-2161a17eee5e.png)

## stack 영영 할당

- 💡 이제 Hello World를 출력할 수 있을까?
    - NO!
- 메소드의 인자 args를 저장할 변수 공간을 스택 프레임 맨 밑에 확보해야한다.
    - 메소드 인자들의 변수 공간을 할당을 한다.

## 출력

- main()메소드의 System.out.println("Hello World");구문이 실행된다.
- 이때는 GPU가 처리하기 때문에 메모리상에는 변화가 없다.

![image](https://user-images.githubusercontent.com/69107255/120887679-3cc15d80-c62f-11eb-9e4d-705921501e7d.png)

## stack frame 종료

- main()메소드의 끝을 나타내는 닫는 중괄호 }를 만나면 stack frame이 소멸된다.
 

![image](https://user-images.githubusercontent.com/69107255/120887877-51eabc00-c630-11eb-8161-94acd5e3c905.png)

- 위에 그림은 main()메소드 종료 후 Runtime Data Area에 stack Area에 stack frame이 사라진 후에 이미지이다.
- main()메소드는 프로그램의 시작점이기도 하지만 종료되는 지점이기도 한 것이다.

### **❓ main()메소드 종료 이후는 어떻게 될까?**

- main()메소드가 종료되면 JRE는 JVM을 종료한다.
- JRE자체 또한 운영체제(OS) 상의 메모리에서 소멸한다.
- 그 후, Runtime Data Area도 소멸된다.


## 공부하면서 느낀점
---
Hello World라는 단 한 문장을 출력하기 위해서 JRE가 JVM을 부팅한 후 JVM이 Java Memory 구조인 Runtime Data Area를 만들어 클래스 영역에 java.lang패키지와 여러 클래스들을 로딩하고 stack 영역에 main()메소드를 배치한 후 stack프래임을 생성한 후 메소드 인자들을 위한 변수 공간까지 만드는 등 바쁘게 움직이는 것을 알게 되었다.

---
## **reference**
- 도서
    - 스프링 입문을 위한 자바 객체 지향의 원리와 이해