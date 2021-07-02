# Singleton pattern

Singleton 패턴은 어떠한 클래스(객체)가 유일하게 1개만 존재 할 때 사용한다.

서로 자원을 공유 할때 사용한다.

여려 명에 사람이 여러 대에 PC로 하나의 프린터기를 두고 연결을 해서 사용할 때 사용되는 패턴이다.

## 📄 SocketClient.java

```java
    public class SocketClient {

        private static SocketClient socketClient = null;

        // Default Constructor 로 객체가 생성되는것을 방지하기 위해서 private 으로 막아준다.
        private SocketClient(){

        }

        /**
        * 외부에서는 SocketClient 메소드를 통해서 접근할 수 있다.
        */
        public static SocketClient getInstance(){
            // 만약 SocketClient가 null일 경우에 객체를 생성한다.
            if(socketClient == null) {
                socketClient = new SocketClient();
            }//end if
            // SocketClient가
            return socketClient;
        }

        public void connect(){
            System.out.println("SocketClient.connect");
        }

    }
```
## 📄 AClazz.java

```java
    public class Aclazz {

        private SocketClient socketClient;

        public Aclazz() {
            this.socketClient = SocketClient.getInstance();
        }

        public SocketClient getSocketClient(){
            return this.socketClient;
        }
    }
```

## 📄 BClazz.java

```java
    public class BClazz {

        private SocketClient socketClient;

        public BClazz(){
            this.socketClient = SocketClient.getInstance();
        }

        public SocketClient getSocketClient() {
            return this.socketClient;
        }

    }
```

```java
    public class Main {

        public static void main(String[] args) {

            Aclazz aclazz = new Aclazz();
            BClazz bClazz = new BClazz();

            SocketClient aClient = aclazz.getSocketClient();
            SocketClient bClient = bClazz.getSocketClient();

            System.out.println("두개의 객체가 동일한가?");
            System.out.println(aClient.equals(bClient));

        }
    }
```

## 싱글톤 방식의 주의점

- 싱글톤 패터이든, 스프링 같은 싱글톤 컨테이너를 사용하든, 객체 인스턴스를 하나만 생성해서 공유하는 싱글톤 방식은 여러 클라이언트가 하나의 같은 객체 인스턴스를 공유하기 때문에 싱글톤 객체는 상태를 유지(stateful)하게 설계하면 안된다.
- 무상태(stateless)로 설계해야 한다.
    - 특정 클라이언트에 의존적인 필드가 있으면 안된다.
    - 특정 클라이언트가 값을 변경할 수 있는 필드가 있으면 안된다.
    - 가급적 읽기만 가능해야 한다.
    - 필드 대신에 자바에서 공유되지 않는, 지역변수, 파라미터, ThreadLocal 등을 사용해야 한다.
- 스프링 빈의 필드에 공유 값을 설정하면 큰 장애가 발생할 수 있다.


```java
public class StatefulService {

    private int price; // 상태를 유지하는 필드

    public void order(String name, int price) {
        System.out.println("name = " + name + " price = " + price);
        this.price = price;
    }

    public int getPrice() {
        return price;
    }
}
```

```java
public class StatefulServiceTest {

    @Test
    void statefulServiceSingleton(){
        AnnotationConfigApplicationContext ac = new AnnotationConfigApplicationContext(TestConfig.class);
        StatefulService statefulService1 = ac.getBean(StatefulService.class);
        StatefulService statefulService2 = ac.getBean(StatefulService.class);

        // ThreadA : A사용자 10000원 주문
        statefulService1.order("userA",10000);

        // ThreadB : B사용자 20000원 주문
        statefulService2.order("userB",20000);

        // ThreadA : 사용자A 주문 금액 조회
        int price = statefulService1.getPrice();
        System.out.println("price = " + price);

        Assertions.assertThat(statefulService1.getPrice()).isEqualTo(20000);

    }

    static class TestConfig{

        @Bean
        public StatefulService statefulService() {
            return new StatefulService();
        }
    }
}
```

ThreadA가 UserA 코드를 호출하고 ThreadB가 UserB 코드를 호출한다고 가정해보자.

StatefulService 의 price 필드는 공유되는 필드인데, 특정 클라이언트가 값을 변경한다.

사용자A의 주문금액은 10000원이 되어야 하는데, 20000원이라는 결과가 나왔다.

진짜 공유필드는 조심해야 한다! 스프링 빈은 항상 무상태(stateless)로 설계해야한다.
