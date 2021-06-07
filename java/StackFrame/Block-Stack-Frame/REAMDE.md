## **목표**

Stack Area에 stack frame안에 if문과 같은 block 구문이 올 경우 메모리 상에 변화에 대해서 공부하고자 합니다. 

## **학습 내용**

- [공부할 코드](#공부할-코드)

## **공부할 코드**

main()메소드 안에 변수 i,k 선언과 동시에 값을 초기화 했다.<br>
if문이 참일 경우 if stack frame안에 m을 선언과 동시에 k + 5에 값으로 초기화 후 k에 m에 값을 대입하고 있다.<br>
if문이 거짓일 경우 if stack frame안에 p를 선언과 동시에 K + 10에 값으로 초기화 후 k에 값에 p에 값을 대입하고 있다.<br>

```java
package com;

public class Hello {
    public static void main(String[] args) {
        int i = 10;
        int k = 20;

        if(i == 10){
            int m = k + 5;
            k = m
        } else {
            int p = k + 10;
            k = p;
        }
    }
}
```

![image](https://user-images.githubusercontent.com/69107255/120889987-fd990980-c63a-11eb-866c-f49c450d7fa2.png)

전처리 후 변수 i 와 k를 선언 후 초기화 후에 메모리 상태이다.<br>
이후에 if문이 실행이 된다. 

## **if문 실행**

if문은 i값이 true 또는 false 조건에 따라서 분기를 일으킨다.<br>
if문에서 i에 값이 10인지 물어보는 조건문이 있다. i에 값은 10이기 때문에 true이다 

![image](https://user-images.githubusercontent.com/69107255/120890083-99c31080-c63b-11eb-8d74-6bee340a3daf.png)

main()메소드의 stack frame안에 if문의 block stack frame이 중첩되어 생성이 된다.

## **if문이 true인 block stack frame 실행**

```java
    int m = k + 5;
```

![image](https://user-images.githubusercontent.com/69107255/120923778-3c969000-c70b-11eb-92fe-a49846656af8.png)

정수형 변수 m을 선언과 동시에 k + 5에 값으로 초기화 하고 있다.<br>

![image](https://user-images.githubusercontent.com/69107255/120923856-ad3dac80-c70b-11eb-8d4a-d9988a2d64d8.png)

```java
    k = m;
```

k의 값을 m에 값으로 대입하고 있다.

## **if(true) block stack frame 종료**

if(true)문의 닫는 `중괄호}`를 만나는 순간 stack frame에서 소멸하게 된다.<br>
이후에 main()메소드에 닫는 중괄호}를 만나면 main()메소드 stack frame또한 소멸되고 JvM은 종료되고 JRE가 리소스또한 OS에 반납한다.<br>
이 때 if문이 false일 때 실행 되는 else문은 stack frame에 배치될 기회도 가지지 못하였다.<br>

![image](https://user-images.githubusercontent.com/69107255/120924387-892f9a80-c70e-11eb-917f-0d1044d9bd9a.png)

### ❓ **이 때 if문 block stack frame안에 있는 m 변수에 값을 사용할 수 있을까? 🤔💭**


**코드**

![image](https://user-images.githubusercontent.com/69107255/120924666-a9ac2480-c70f-11eb-924c-76c4e1d6367e.png)

위에 [공부할 코드](#공부할-코드)에서 봤던 코드와 똑같은 코드이다. if문 block stack frame밖에서 단지 m변수에 값을 출력해보았다.

**결과**

![image](https://user-images.githubusercontent.com/69107255/120924534-2559a180-c70f-11eb-9d7e-24c99756c5b5.png)

결과는 `java: cannot find symbol symbol:   variable m` 한국어로 해석하면 m이라는 변수를 찾을 수 없다는 컴파일 에러가 발생한다.<br>

위 그림에 코드에서 11번째 라인 if(true)에 닫는 중괄호를 만나는 순간 [if(true) block stack frame 종료](#if(true)-block-stack-frame-종료)그림과 같이 if(ture) block stack frame은 main()메소드 stack frame 메모리 상에서 소멸하게 된다.<br>
따라서 if(ture) block stack frame외부에서는 m변수가 존재하지 않기 때문에 사용할 수 없는 것이다.

