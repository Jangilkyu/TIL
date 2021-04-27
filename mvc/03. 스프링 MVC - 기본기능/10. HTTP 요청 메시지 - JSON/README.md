# HTTP 요청 메시지 - JSON

이번에는 HTTP API에서 주로 사용하는 JSON 데이터 형식을 조회해보자.

기존 서블릿에서 사용했던 방식과 비슷하게 시작해보자.

## RequestBodyJsonController

- HttpServletRequest를 사용해서 직접 HTTP 메시지 바디에서 데이터를 읽어와서, 문자로 변환한다. 
- 문자로 된 JSON 데이터를 Jackson 라이브러리인 `objectMapper` 를 사용해서 자바 객체로 변환한다.

```java
    @Slf4j
    @Controller
    public class RequestBodyJsonController {

        // JSON을 사용하기 때문에 ObjectMapper가 필요하다.
        private ObjectMapper objectMapper = new ObjectMapper();

        @PostMapping("request-body-json-v1")
        public void requestBodyJsonV1(HttpServletRequest request, HttpServletResponse response) throws IOException {
            ServletInputStream inputStream = request.getInputStream();
            String messageBody = StreamUtils.copyToString(inputStream, StandardCharsets.UTF_8);

            log.info("messageBody = {}", messageBody);
            HelloData helloData = objectMapper.readValue(messageBody, HelloData.class);
            log.info("username = {}, age={}",helloData.getUsername(),helloData.getAge());

            response.getWriter().write("ok");
        }

    }
```
- **실행**

- 1. POST방식으로 http://localhost:8080/request-body-json-v1 url로 요청
    - raw, JSON, content-type: application/json
    - {"username":"hello", "age":20}

![image](https://user-images.githubusercontent.com/69107255/116109417-b50f3780-a6ef-11eb-9bdf-e4dc66d8f799.png)

- 2. 결과가 잘 로그에 찍혀서 나오는 것을 확인 할 수 있다.

![image](https://user-images.githubusercontent.com/69107255/116109992-41215f00-a6f0-11eb-8ab4-0a002d88b8e5.png)


## requestBodyJsonV2 - @RequestBody 문자 변환

- `@RequestBody`를 사용해서 HTTP 메시지에서 데이터를 꺼내고 messageBody에 저장한다.
문자로 된 JSON 데이터인 `messageBody` 를 `objectMapper` 를 통해서 자바 객체로 변환한다.

```java
    /**
    * @RequestBody
    * HttpMessageConverter 사용 -> StringHttpMessageConverter 적용 
    *
    * @ResponseBody
    * - 모든 메서드에 @ResponseBody 적용
    * - 메시지 바디 정보 직접 반환(view 조회X)
    * - HttpMessageConverter 사용 -> StringHttpMessageConverter 적용
    */

    @ResponseBody
    @PostMapping("request-body-json-v2")
    public String requestBodyJsonV2(@RequestBody String messageBody) throws IOException {

        log.info("messageBody = {}", messageBody);
        HelloData helloData = objectMapper.readValue(messageBody, HelloData.class);
        log.info("username = {}, age={}",helloData.getUsername(),helloData.getAge());

        return "ok";
    }
```


문자로 변환하고 다시 json으로 변환하는 과정이 불편하다. @ModelAttribute처럼 한번에 객체로 변환할 수는 없을까?

## requestBodyJsonV3 - @RequestBody 객체 변환

- **@RequestBody 객체 파라미터**
    - `@RequestBody HelloData data` -> @RequestBody 에 직접 만든 객체를 지정할 수 있다.

- `HttpEntity` , `@RequestBody` 를 사용하면 HTTP 메시지 컨버터가 HTTP 메시지 바디의 내용을 우리가 원하는 문자나 객체 등으로 변환해준다.
HTTP 메시지 컨버터는 문자 뿐만 아니라 JSON도 객체로 변환해주는데, 우리가 방금 V2에서 했던 작업을 대신 처리해준다.

- `@RequestBody`는 생략 할 수 없다. 
    - 이유는 스프링은 **@ModelAttribute** , **@RequestParam** 해당 생략시 다음과 같은 규칙을 적용한다.
    - `String` , `int` , `Integer` 같은 단순 타입 = `@RequestParam`
    - 나머지는 `@ModelAttribute` (argument resolver 로 지정해둔 타입 외)

따라서 이 경우 HelloData에 @RequestBody 를 생략하면 @ModelAttribute 가 적용되어버린다.<br>
`HelloData data` 👉 `@ModelAttribute HelloData data` 따라서 생략하면 HTTP 메시지 바디가 아니라 요청 파라미터를 처리하게 된다.

- HTTP 요청시에 content-type이 application/json인지 꼭! 확인해야 한다 그래야 JSON을 처리할 수 있는 HTTP 메시지 컨버터가 실행된다.
```java
    /**
        * @RequestBody 생략 불가능(@ModelAttribute 가 적용되어 버림)
        * HttpMessageConverter 사용 -> MappingJackson2HttpMessageConverter (content-type: application/json)
    */
    @ResponseBody
    @PostMapping("request-body-json-v3")
    public String requestBodyJsonV3(@RequestBody HelloData helloData) throws IOException {

        log.info("username = {}, age={}",helloData.getUsername(),helloData.getAge());

        return "ok";
    }
```

## requestBodyJsonV4 - HttpEntity

```java
    @ResponseBody
    @PostMapping("request-body-json-v4")
    public String requestBodyJsonV4(HttpEntity<HelloData> httpEntity) throws IOException {
        HelloData helloData = httpEntity.getBody();

        log.info("username = {}, age={}",helloData.getUsername(),helloData.getAge());

        return "ok";
    }
```


## requestBodyJsonV5

- @ResponseBody
- 응답의 경우에도 `@ResponseBody` 를 사용하면 해당 객체를 HTTP 메시지 바디에 직접 넣어줄 수 있다. 물론 이 경우에도 `HttpEntity` 를 사용해도 된다.

```java
    /**
    * @RequestBody 생략 불가능(@ModelAttribute 가 적용되어 버림)
    * HttpMessageConverter 사용 -> MappingJackson2HttpMessageConverter (content-type: application/json)
    *
    * @ResponseBody 적용
    * - 메시지 바디 정보 직접 반환(view 조회X)
    * - HttpMessageConverter 사용 -> MappingJackson2HttpMessageConverter 적용
    (Accept: application/json)
    */

    @ResponseBody
    @PostMapping("request-body-json-v5")
    public HelloData requestBodyJsonV5(@RequestBody HelloData data) throws IOException {

        log.info("username = {}, age={}",data.getUsername(),data.getAge());

        return data;
    }
```

- @RequestBody 요청
JSON 요청 HTTP 메시지 컨버터 객체

![image](https://user-images.githubusercontent.com/69107255/116113645-a32f9380-a6f3-11eb-898f-a4693bbd262a.png)

![image](https://user-images.githubusercontent.com/69107255/116113714-b5113680-a6f3-11eb-87f6-4f5205597439.png)
