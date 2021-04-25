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