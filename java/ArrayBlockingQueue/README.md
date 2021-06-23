ArrayBlockingQueue는 Array로 구현된 BlockingQueue이다.

- Queue의 크기가 정해져 있기 때문에 무한히 아이템을 추가할 수 없다.
- 추가되는 아이템은 순서가 있다.
- `FIFO(First In First Out)` 순서를 따른다.
- Queue에서 아이템을 가져올 때 비어있으면 null을 리턴하지 않고 아이템이 추가될 때까지 기다린다.
- 위와 반대로 아이템을 추가할 때 Queue가 가득차 있으면 공간이 생길 때까지 기다린다.
- 멀티 쓰레드 환경에서 사용하기 위해 구현되었으며 내부적으로 동시성에 안전하기 때문에 synchronized 구문 없이 사용할 수 있다.

## **ArrayBlockingQueue 생성**

다음과 같이 객체를 생성할 수 있다. 인자로 `Queue의 크기`를 전달한다.

```java
    int queueCapacity = 10;
    ArrayBlockingQueue<Integer> queue = new ArrayBlockingQueue<Integer>(queueCapacity);
```


## **add() : 아이템 추가**

`add()`메소드로 아이템을 `Queue`에 추가할 수 있다. FIFO 순서로 Queue에 저장된다.

```java
queue.add(1);
queue.add(2);
System.out.println(queue);

queue.add(3);
System.out.println(queue);

queue.add(4);
queue.add(5);
System.out.println(queue);

// 결과 
[1, 2]
[1, 2, 3]
[1, 2, 3, 4, 5]
```

만약 Queue의 크기보다 더 많은 아이템을 추가하려고 하면 `IllegalStateException`하며 `Queue full`이라고 Exception이 발생한다.


## **put() : 공간이 생길 때까지 기다렸다가 아이템 추가**

```java
    try {
        queue.put(1);
        System.out.println("Queue: " + queue);
        queue.put(2);
        System.out.println("Queue: " + queue);
        queue.put(6);
        System.out.println("Queue: " + queue);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
```



---
**참고**

[ArrayBlockingQueue 사용 방법](https://codechacha.com/ko/java-arrayblockingqueue/)