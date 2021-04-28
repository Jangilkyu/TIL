# Adapter pattern

## Adapter란?

- Adapter는 실생활에서는 110V를 220V로 변경해주거나, 그 반대로 해주는 흔히 돼지코라고 불리는 변환기를 예로 들 수 있다.
- 호환성이 없는 기존 클래스의 인터페이스를 변환하여 재사용 할 수있도록 한다.
- SOLID중에서 개방폐쇄 원칙(OCP)를 따른다.

## 110V 전압 인터페이스 - 📄 Electronic120V.java

```java
    public interface Electronic110V {

        void powerOn();

    }
```

## 220V 전압 인터페이스 - 📄 Electronic220V.java

```java
    public interface Electronic220V {

        void connect();

    }
```

## 110V를 지원하는 헤어드라이기 - 📄 HairDryer.java

```JAVA
/**
 * 110V를 지원하는 헤어드라이기
 */
public class HairDryer implements Electronic110V{
    @Override
    public void powerOn() {
        System.out.println("헤어 드라이기 110V on");
    }
}

```

## 220V를 지원하는 에어컨 - 📄 AirConditioner.java

```JAVA
/**
 * 220V를 지원하는 에어컨
 */
public class AirConditioner implements Electronic220V{
    @Override
    public void connect() {
        System.out.println("에어컨 220V on");
    }
}
```

`110V전용인 헤어드라이기`와 `220V를 지원하는 에어컨`이 있다.
IF 일본으로 여행을 갔을 때 `adapter(어댑터)`가 필요하다.

## 110V와 220V에 adapter역할을 하는 클래스 - 📄 SocketAdapter.java

SocketAdapter클래스는 Electronic110V를 꽂을 수 있다.
만약 220V용 전압을 사용한다면 SocketAdapter를 연결하여 110V 전압을 사용할 수 있게 된다.

```java
    public class SocketAdapter implements Electronic110V{
        private Electronic220V electronic220V;

        public SocketAdapter(Electronic220V electronic220V){
            this.electronic220V = electronic220V;
        }

        @Override
        public void powerOn() {
            electronic220V.connect();
        }
    }
```

## Main 클래스

```java
public class Main {

    public static void main(String[] args) {

        // ==================== 110V ====================

        // 객체 생성
        HairDryer hairDryer = new HairDryer();
        // 헤어드라이기는 110V전압이다.
        // 따라서 Electronic110V electronic110V = hairDryer
        // IS-A관계로 powerOn()를 실행 할 수 있다.
        connect(hairDryer);

        // ==================== 220V ====================

        // 객체 생성
        Cleaner cleaner = new Cleaner();
        // 청소기는 220V용 전압 콘센트이다.
        // 콘센트 모양이 다르기때문에 바로 110V에 꽂을 수 없다.
        // 따라서, Adapter(어댑터)역할을 하는 SocketAdapter클래스를 통해 220V 콘센트에 110V를 연결하여야한다.
        Electronic110V adapter = new SocketAdapter(cleaner);
        connect(adapter);

        AirConditioner airConditioner = new AirConditioner();
        Electronic110V airAdapter = new SocketAdapter(airConditioner);
        connect(airAdapter);

    }

    // 콘센트 역할을 하는 메소드
    public static void connect(Electronic110V electronic110V){
        electronic110V.powerOn();
    }

}
```