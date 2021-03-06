# **IP(인터넷 프로토콜)**

복잡한 인터넷망에서 `Hello World`라는 메시지를 해외에 있는 친구에게 보낼 때 최소한에 규칙이 필요한데 **IP주소**로 가능하다.

![image](https://user-images.githubusercontent.com/69107255/125455370-5f98ec92-f087-4fad-ae4b-f578f822fdcd.png)

- **인터넷 프로토콜 역할**
    - 지정한 IP 주소(IP address)에 데이터를 전달
    - 패킷(Packet)이라는 통신 단위로 데이터를 전달    

![image](https://user-images.githubusercontent.com/69107255/125456770-a9d5d86b-1b21-495e-95a9-c2ebb28cdff5.png)

**클라이언트 패킷 전달**

IP패킷에 **보내고자 하는 출발지 IP주소**와 **상대방 목적지 IP주소**와 **메시지**를 넣고 IP패킷을 인터넷 망에 던진다.
IP Protocol에 의해서 서버들이 규약을 따르고 있기 때문에 패킷 정보에 내용들을 파악한다. 노드끼리 목적지인 200.200.200.2를 받을 수 있는 서버가 어디인지 던지다 보면 목적지에 도달하게 된다.

![image](https://user-images.githubusercontent.com/69107255/125458908-46a0b090-5af7-4c9d-aeb2-44240577f1e7.png)

**서버 패킷 전달**

서버에서 `Hello Wolrd`라는 메시지를 받았을 경우 **클라이언트 패킷 전달**과 동일하게 IP패킷 정보 안에 **출발지IP**,**목적지IP**,**메시지**를 만들어서 인터넷 망에 던져서 노드들을 타면서 목적지인 100.100.100.1을 받을 수 있는 곳이 어디인지 던지다 보면 최종적으로 클라이언트에 도달하게 된다.

![image](https://user-images.githubusercontent.com/69107255/125460170-8b755771-c20c-4ac3-a4dc-694843c8921e.png)

요청할때와 응답할때에 노드는 서로 다른곳으로 전달하는것을 **클라이언트 패킷 전달**과 **서버 패킷 전달**을 통해서 `인터넷 망`이 복잡하기 때문에 다르다는 것을 알아 수 있다.

### IP 프로토콜의 한계

- **비연결성**
    - 패킷을 받을 대상이 없거나 서비스 불능 상태여도 패킷을 전송
    - 해외에 친구가 있을 것이라고 가정하고 메시지를 전달했지만 친구에 서버(pc)가 꺼져있는경우
    - 편지를 쓸 때 친구가 살지 않더라도 보내는경우와 같다.
- **비신뢰성**
    - 중간에 패킷이 사라지면?
        - 노드를 타고 목적지로 가다가 서버가 죽은경우  
    - 패킷이 순서대로 오지 않는다면?
- 프로그램 구분
    - 같은 IP를 사용하는 서버에서 통신하는 애플리케이션이 둘 이상이면?


## **인터넷 프로토콜(IP) 스택의 4계층**

HTTP를 이해하기 위해서는 TCP/IP 프로토콜에 대하여 이해를 하고 있어야한다.

TCP/IP에서 중요한 개념 중에 하나는 **계층(Layer)** 이다.

TCP/IP는 `애플리케이션 계층`, `전송 계층`, `인터넷 계층`,  `네트워크 인터페이스 계층` 4계층으로 나뉘어 있다.

- **🤔❓ TCP/IP는 왜 계층화로 나뉘어 있을까?**
    - 만약 인터넷이 하나의 프로토콜로 되어져 있다면, 변경사항이 발생 시 전체를 변경해야하지만,
    계층화가 되어 있다면 사양이 변경된 해당 계층만 변경하면 된다.

![image](https://user-images.githubusercontent.com/69107255/125464370-41d9dbe6-ce3d-4ca5-acdc-aa00e1789485.png)

- 애플리케이션 계층
    - 유저에게 제공되는 애플리케이션에서 사용하는 통신의 움직음을 결정하고 있다.

- 전송 계층
    - 트랜스포트 계층이라고도 한다.
    - 애플리케이션 계층에서 네트워크로 접속되어 있는 2대의 컴퓨터 사이의 데이터 흐름을 제공한다.
    - 전송 계층에서는 다른 성질을 가지고 있는 TCP와 UDP 두 가지 프로토콜이 있다.
- 인터넷 계층
    - 네트워크 계층이라고도 한다.
    - 네트워크 상에서 패킷의 이동을 다룬다.
    - 어떠한 경로를 거쳐서 상대방 컴퓨터까지 패킷을 보낼지를 결정한다. 
    - 인터넷에 경우 상대방 컴퓨터에 도달하는 동안에 인터넷 망에서  여러 대의 컴퓨터와 네트워크 기기를 거쳐서 상대방에게 배송된다.
- 네트워크 인터페이스 계층
    - 링크계층 또는 데이터 링크계층이라고 한다.
    - 네트워크에 접속하는 하드웨어적인 면을 다룬다.

## **TCP/IP 통신의 흐름**

![image](https://user-images.githubusercontent.com/69107255/126319885-bfab82b7-edb9-40bc-a263-341372f0a919.png)

TCP/IP로 통신을 할 때 계층을 순서대로 거쳐 상대와 통신을 한다.

송신측, 즉 클라이언트 측은 애플리케이션 계층에서 부터 내려가고, 수신측(서버)쪽은 애플리케이션 계층으로 올라간다.

1. 클라이언트의 애플리케이션 계층에서 "어느 웹페이지를 보고싶다" 라는 HTTP 리퀘스트를 지시한다.
2. 전송 계층에서는 애플리케이션 계층에서 받은 데이터(HTTP 메시지)를 통신하기 쉽게 조각내어 "안내포트"와 "포트 번호"를 붙혀 네트워크 계층으로 전달한다.
3. 네트워크 계층(IP)에서는 수신지 MAC 주소를 추가해서 링크 계층에 전달한다.

 ![image](https://user-images.githubusercontent.com/69107255/126486310-e277ddca-048c-45c1-ae60-c68acfb5ace3.png)


## TCP 특징(전송 제어 프로토콜)

- 신뢰할 수 있는 프로토콜이다.
- 현재는 대부분 TCP를 사용한다.
- 연결지향 - TCP 3 way handshake(가상 연결)
- 데이터 전달 보증
    - 만약 패킷이 누락이 될 시 메시지를 상대방 쪽에서 받았는지 못받았는지 알 수 있다.
- 순서 보장
    - 클라이언트쪽에서 `패킷1`, `패킷2`,`패킷3` 순서로 서버로 전송했는데 `패킷1`, `패킷3`, `패킷2` 순서로 도착 시 패킷2부터 다시 보내라고 한다.


## UDP(사용자 데이터그램 프로토콜)

- 데이터 전달 및 순서가 보장되지 않지만, 단순하고 빠르다.
- 기능이 거의 없어서 하얀 도화지에 비유한다.
- 연길지향 - TCP 3 way handshake 지원하지 않음
- 데이터 전달 보증하지 않는다.
- 순서도 보장하지 않는다.

## PORT

- IP가 아파트이면 port는 아파트 호 수에 비유할 수 있다. 

- 0 ~ 65535 할당 가능
- 0 ~ 1023사이는 잘 알려져 있는 PORT번호이므로 사용하지 않는것을 권장한다.
    - FTP - 20, 21
    - TELNET - 23
    - HTTP - 80
    - HTTPS - 443

## DNS

- IP의 단점
    - IP는 기억하기가 너무 어렵다.
    - IP는 변경될 가능성이 있다.
