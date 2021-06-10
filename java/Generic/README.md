# Generics 기초

- parameterized types
- 많은 알고리즘들이 자료형에 관계없이 같은 로직을 적용하고 있다.
    - 예를 들어, 정렬하는 데이터들이 Integer 타입일 수도 있고, String 타입일 수도 있다.
- 어던 알고리즘에든 Object 객체 타입을 처리하고자 하는 데이터 타입으로 할 수 있찌만, 이 경우 항상 캐스트 연산자가 필요하다.
- Generics는 반드시 reference 타입으로만 지정 할 수 있다.(primitive Data)는 안된다.
- 서로 다른 reference 타입 간에는 '='연산자를 사용할 수없다.
- Generics는 type safety를 개선한다.


```java
class Gen<T> {

    T ob;
    Gen(T o){
        ob = o;
    }

    T getob() {
        return ob;
    }

    void showType(){
        System.out.println("ob.getClass().getName() = " + ob.getClass().getName());
    }

}

public class GenDemo {

    public static void main(String[] args) {
        Gen<Integer> iOb = new Gen<Integer>(88);// Generic class의 객체 생성

        iOb.showType();

        int v = iOb.getob();
        System.out.println();

        Gen<String> strOb = new Gen<String>("Generics Test"); // Generic class의 객체 생성
        strOb.showType();
        String str = strOb.getob();
        System.out.println("str = " + str);

    }
}
```

- Generics는 reference 타입에만 사용할 수 있음.

```java
    Gen<int> intOb = new Gen<int>(55); //error
```

- Gen<T>가 자료형이 되므로 T가 일치해야 같은 자료형 같은 데이터가 됨
```java
    // iOb는 Integer자료형이고 strOb는 String임
    iOb = strOb // error
```

## Bounded Types

- Type parameter를 제한할 필요가 있는 경우에 bounded type을 이용한다.

```java
    class NumericFns<T> {
        T num;
        NumericFns<T n>{
            num = n;
        }

        double reciprocal(){
            return 1 / num.doubleValue(); // num의 역수를 구하고자함
        }
    }
```

## Type parameter가 2개인 Generic class

```java

class TwoGen<T, V>{


    
}



```