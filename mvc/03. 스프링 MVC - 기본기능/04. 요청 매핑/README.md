# 요청 매핑

## **@RestController**
- `@Controller` 는 반환 값이 String 이면 뷰 이름으로 인식된다. 그래서 뷰를 찾고 뷰가 랜더링 된다.
- `@RestController` 는 반환 값으로 뷰를 찾는 것이 아니라, HTTP 메시지 바디에 바로 입력한다. 따라서 실행 결과로 ok 메세지를 받을 수 있다. @ResponseBody 와 관련이 있는데, 뒤에서 더 자세히 설명한다.

## **@RequestMapping("/hello-basic")**
`/hello-basic` URL 호출이 오면 이 메서드가 실행되도록 매핑한다.
대부분의 속성을 `배열[]` 로 제공하므로 다중 설정이 가능하다. `{"/hello-basic", "/hello-go"}`

## HTTP 메서드 매핑

- HTTP 메서드
    - `@RequestMapping` 에 `method` 속성으로 HTTP 메서드를 지정하지 않으면 HTTP 메서드와 무관하게 호출된다.
모두 허용 **GET, HEAD, POST, PUT, PATCH, DELETE**

- 만약 여기에 **POST 요청**을 하면 스프링 MVC는 **HTTP 405 상태코드(Method Not Allowed)를 반환**한다.

```java
    /**
    * method 특정 HTTP 메서드 요청만 허용
    * GET, HEAD, POST, PUT, PATCH, DELETE
    */
    @RequestMapping(value = "/mapping-get-v1", method = RequestMethod.GET) 
    public String mappingGetV1() {
        log.info("mappingGetV1");
        return "ok";
    }
```

## HTTP 메서드 매핑 축약

```java
    /**
    * 편리한 축약 애노테이션 (코드보기) * @GetMapping
    * @PostMapping
    * @PutMapping
    * @DeleteMapping
    * @PatchMapping
    */
    @GetMapping(value = "/mapping-get-v2") public String mappingGetV2() {
        log.info("mapping-get-v2");
        return "ok";
    }
```

HTTP 메서드를 축약한 애노테이션을 사용하는 것이 더 직관적이다. 코드를 보면 내부에서 
`@RequestMapping` 과 `method` 를 지정해서 사용하는 것을 확인할 수 있다.

## HTTP 메서드 매핑 축약 - @GetMapping

```java
    /**
    * 편리한 축약 애노테이션 (코드보기) * @GetMapping
    * @PostMapping
    * @PutMapping
    * @DeleteMapping
    * @PatchMapping
    */
    // 실제로 @GetMapping 안에 들어가면 
    @GetMapping(value = "/mapping-get-v2") public String mappingGetV2() {
    log.info("mapping-get-v2");
        return "ok";
    }
```

실제로 `@GetMapping`애노테이션 내부를 살펴보면 아래 그림과 같이 `@RequestMapping(method = RequestMethod.GET)`이 있는 것을 확인 할 수 있다.

![image](https://user-images.githubusercontent.com/69107255/115999793-2b486700-a628-11eb-9cc7-9fe1ef342640.png)


## PathVariable(경로 변수) 사용

최근 HTTP API는 다음과 같이 리소스 경로에 식별자를 넣는 스타일을 선호한다.

ex)<br>
/mapping/userA<br>
/users/1<br>

```java
/*
* PathVariable 사용
* 변수명이 같으면 생략 가능
* @PathVariable("userId") String userId -> @PathVariable userId
*/ 
@GetMapping("/mapping/{userId}")
  public String mappingPath(@PathVariable("userId") String data) {
log.info("mappingPath userId={}", data);
      return "ok";
  }
```

## PathVariable(경로 변수)애 사용

1. http://localhost:8080/mapping/userA

2. `@RequestMapping` 은 URL 경로를 템플릿화 할 수 있는데, `@PathVariable` 을 사용하면 매칭 되는 부분을 편리하게 조회할 수 있다.
3. `@PathVariable` 의 이름과 파라미터 이름이 같으면 생략할 수 있다.


## PathVariable 사용 - 다중

`userId`를 userA로 주문번호인 `orderId`를 100으로 받아서 log를 통하여 찍어봤다.

```java
    /**
     * PathVariable 사용 다중
     */
    @GetMapping("/mapping/users/{userId}/orders/{orderId}")
    public String mappingPath(@PathVariable String userId, @PathVariable Long
            orderId) {
        log.info("mappingPath userId={}, orderId={}", userId, orderId);
        return "ok";
    }
```

### 결과

![image](https://user-images.githubusercontent.com/69107255/116001961-3e603480-a632-11eb-96bd-742688922c97.png)
