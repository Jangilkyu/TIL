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