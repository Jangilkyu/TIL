# String Class

> 국비지원 학원에서 수강 중에 [문자열형](https://github.com/Jangilkyu/sist-fullstack-class/tree/master/Java/14.String)에 대해서 배웠었다.

### String Class 선언 방법

- String은 참조형 객체 클래스이다. 또한, String 객체는 불변 객체이기 때문에 동일한 객체가 공유될 수 있다.

- String Class는 2가지의 방법으로 선언을 할 수 있다.
    1. literal
    2. new연산자

### literal

```java
    String str = "ABCD";
```

### new 연산자

```java
    String str1 = new String("ABCD");
```

둘 다 sout을 해보면 "ABCD"라는 동일한 값이 출력이 되지만 차이가 있다.

👆 String 클래스는 선언 시 literal은 `string pool`이라는 공간에 적재가 되고, new 연산자를 사용했을 경우 Heap 영역에 적재가 된다.

![image](https://user-images.githubusercontent.com/69107255/116778241-adfb7700-aaab-11eb-9938-1948aa4f3e11.png)

literal과 new연산자 비교
 
```java
    String str = "ABCD"; 
    String str1 = new String("ABCD");

    System.out.print(str == str1); // false
```

### 👉**false인 이유는?**

분명 `str`과 `str1` 변수는 **"ABCD"** 라는 동일한 값을 가지고 있다.<br>
하지만 `literal`타입과 `new연산자`의 선언 시 객체가 저장되는 위치가 다르기 때문이다.

---

literal끼리 비교

```java
    String str = "ABCD";
    String str1 = "ABCD";

    System.out.print(str == str1); // true
```

### 👉 **true인 이유는?**

str이 생성될 때 string pool(문자열 저장소)에 "ABCD"라는 값을 가지는 String객체가 생성된다.
이후에 str1을 생성하게 되면 String클래스는 불변 객체이기 때문에 미리 `intern()` 메소드에서 탐색이 된 후 미리 생성된 객체가 공유되어 단순 비교인 ==으로 true값이 나온다.

결론은 `쌍따옴표`를 사용해 문자열을 정의하면 아래와 같은 해석이다.
```java
    String a = "ABCD";
    // 위 구문은 아래 구문으로 해석한다.
    String b = new String(new char[]{'A', 'B', 'C', 'D'}).intern();
```

![image](https://user-images.githubusercontent.com/69107255/116779566-f5850180-aab1-11eb-8d6b-2a5e829c6196.png)

위에 그림처럼 String클래스에 내부를 살펴보면 결국 Char 배열로 생성된 불변 객체 값이다.

---

### 🎈**String.intern()**

`String`클래스에서는 `intern()`메소드가 아래의 그림과 같이 정의되어있다.

![image](https://user-images.githubusercontent.com/69107255/116779647-82c85600-aab2-11eb-85fc-046a8d4cb606.png)

`native` 키워드는 java 프로그램에서 다른 언어(C, C++, 어셈블리 등으로 작성된 코드를 실행할 수 있는 JNI(Java Native Interface) 키워드이다.

```java
    String str1 = "Hello"; // 문자열을 string pool에 담는다.
    String str2 = "Hello"; // 이미 Hello는 string pool에 담았으므로 다시 불러와서 정의가 된다.
    String str3 = "Hello"; // 이미 Hello는 string pool에 담았으므로 다시 불러와서 정의가 된다.
```

`str1`,`str2`,`str3`세 개의 변수는 모두 하나의 객체를 가리키고 있다.

`.java파일`을 compile하게되면 현재 컴파일한 현재 클래스의 정보가 들어있는 `.class파일`이 생성된다.

compile 시 "Hello"라는 문자를 사용한다는 것을 알 수 있기 때문에 "Hello"라는 문자열은 .class파일의 String pool(문자열 저장소)에 들어가게 된다.

아래 그림에 소스를 컴파일 한 후 만든 .class파일을 메모장에 열어 보았다. Hello는 하나만 있는 것을 확인 할 수 있다.

![image](https://user-images.githubusercontent.com/69107255/116777076-3fb4b580-aaa7-11eb-9ba9-c759b2c7a36e.png)

```java
    String str1 = new String("Hello");
    String str2 = new String("Hello");
    String str3 = new String(new char[]{'H','e','l','l','o'});

    System.out.println(System.identityHashCode(str1));
    System.out.println(System.identityHashCode(str2));
    System.out.println(System.identityHashCode(str3));

// 결과
93122545
2083562754
1239731077
```
### 👉 **왜 다른 hashcode가 출력될까?**

str1, str2, str3는 전부 new String(String)을 이용해 생성했지만 str1, str2, str3 전부 다른 hashcode가 나왔다. 이 뜻은 서로 다른 객체라는 것이다.

"Hello"라는 문자열을 가지고 String을 new 즉, 객체를 생성했지만, 실제로 만들어진 객체는 "Hello"라고 인자로 넣은 객체가 아니라 new 연산자를 사용했기 때문에 Hello를 가지는 새로운 객체를 만들어 준 것이다.

결국 컴파일해서 실행하면 총 3개의 "Hello"가 메모리에 로딩되게 된다.
```
    1. "Hello"가 String Pool영역에 저장된다.
    2. String Pool에 있는 "Hello"를 통해 Heap영역에 새로운 String 객체를 만든 str1이 가리키고 있다.
    3. String Pool에 있는 "Hello"를 통해 Heap영역에 새로운 String 객체를 만든 str2이 가리키고 있다.
    4. String Pool에 있는 "Hello"를 통해 Heap영역에 새로운 String 객체를 만든 str3이 가리키고 있다.
```

같은 문자열을 저장하고있는 String이지만 객체가 4개나 생성이 되었다.

`intern()`메소드를 사용해 새로 만들어지는 String객체를 상수화 시켜준다.

Heap에 새롭게 만들어지는 객체를 사용하지 않고, String Pool(문자열 저장소)에서 문자열을 조회한 후 존재한다면 존재하는 객체를 반환 하고, 없을 경우 저장하는 메소드이다.

`intern()`메소드를 통하여 불변 객체가 가지는 동일한 객체를 공유할 수 있고 상수화되기 때문에 동일한 객체가 단 한개만 생긴다.

```java
    String str = "Hello";
    String str1 = new String("Hello").intern();
    String str2 = new String("Hello").intern();

    System.out.println(System.identityHashCode(str));
    System.out.println(System.identityHashCode(str1));
    System.out.println(System.identityHashCode(str2));

// 결과
2083562754
2083562754
2083562754
```

str, str1, str2 모두 동일한 hascode값을 가지게 되었다.
`intern()`메소드를 활용해 String Pool에서 조회한 후 동일한 객체가 단 한개만 생성 된 것을 확인 할 수있다.


### 👉 **그렇다면 intern()을 사용해도 될까?**

intern()에 단점이 있다. [java api](https://docs.oracle.com/javase/8/docs/api/)에 Java.lang.String에 intern()메소드를 확인해보자.

![image](https://user-images.githubusercontent.com/69107255/116781519-561a3b80-aabe-11eb-8559-2a549103e1c3.png)

빨간 네모 부분만 확인해보자.

```
1. String Pool에 있는 문자열들은 조회 후 같은 문자열이 있다면 그 문자열을 반환하고,
2. 같은 문자열이 없다면 String pool에 String객체를 추가한 후 추가한 객체를 반환한다.
```

따라서 `intern()`메소드는 생성되는 객체가 아닌 String pool에 있는 객체를 가리키게 된다. 때문에 Heap메모리를 아낄 수 있는 장점이 있다.

### 👉 **`intern()`메소드에 단점은?**

1. String 객체를 만들어야한다.
2. String의 equals()메소드를 이용해 String Pool에 있는 문자열과 비교하는 작업을 거쳐야하기 때문에 시간이 걸린다.
3. intern()메소드는 native메소드이기 때문에 네이티브에서 메모리 관리를 한다. 따라서 자바 내에서 문자열에 대한 메모리 관리가 불가능하게 된다.

---

각 선언 방법에 따라 걸리는 시간을 알아보자.

```java
    long startTime = System.currentTimeMillis();
    for ( int i = 0 ; i < 5000000; i++ ) {
        String str = "Hello";
    }
    long endTime = System.currentTimeMillis();
    System.err.println("String pool = "  + ( endTime - startTime));

    long startTime1 = System.currentTimeMillis();
    for ( int i = 0 ; i < 5000000; i++ ) {
        new String("Hello");
    }
    long endTime1 = System.currentTimeMillis();
    System.err.println("new String = "  + ( endTime1 - startTime1));

    long startTime2 = System.currentTimeMillis();
    for ( int i = 0 ; i < 5000000; i++ ) {
        new String("Hello").intern();
    }
    long endTime2 = System.currentTimeMillis();
    System.err.println("new String intern = "  + ( endTime2 - startTime2));

// 결과
String pool = 12
new String = 11
new String intern = 2755
```

String intern은 new String에 시간과 String Pool(문자열 저장소)를 equals()메소드를 통해 조회하는 시간까지 소요되기 때문에 속도가 많이 느리다.

intern()메소드를 사용할 때는 1~2번 사용되는 String객체를 상수화 하면 GC대상이 아니기 때문에 메모리를 버리게 된다.

### 🎈**문자열 관리 하는 법**

1. 정적문자열 인 ""따옴표로 감싼 리터럴 문자열을 남발하지 말자. 너무 많게 되면 선언부터 사용까지 힘들어진다.
2. 암호화 또는 hash처럼 문자를 세부적으로 다루지 않는 한 new String으로 클래스 초기화를 할 필요없다.
3. 동적으로 생성된 문자열은 대부분 String Pool(문자열 저장소)에 담지 않은 String 클래스이기 때문에, 값 비교엔 `equals()` 메소드를 이용해서 비교하는 것이 좋다. 내부적으로 String.equals 메소드가 값을 비교하도록 정의되어 있기에, 문자열 비교에 효율적일 수밖에 없을 것이다.

---

### 🎈**equals() 메소드**

문자열은 생성방법과 상관없이 동일한 비교를 하기 위해서 `.equals()` 메소드를 사용한다.

![image](https://user-images.githubusercontent.com/69107255/116787905-cb4b3800-aae1-11eb-8daf-91ac6e60c485.png)

```java
    String str = new String("Hello");
    String str1 = "Hello";

    System.out.print(str == str1); // false
    System.out.print(str.equals(str1); // true   
```

- 위와 같이 비교할 때는 단순비교에 경우에 false값이 반환이 되고, equals() 메소드를 사용 후 비교하면 true가 반환된다. 이유는 Value 값을 비교하는지 객체의 주소값을 비교하는가의 차이이다.