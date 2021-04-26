# HTTP 요청 - 기본, 헤더 조회

애노테이션 기반의 스프링 컨트롤러는 다양한 파라미터를 지원한다.
이번 시간에는 HTTP 헤더 정보를 조회하는 방법을 알아보자.

## RequestHeaderController

```java
@Slf4j
@RestController
public class RequestHeaderController {
    @RequestMapping("/headers")
    public String headers(HttpServletRequest request,
                          HttpServletResponse response,
                          HttpMethod httpMethod,
                          Locale locale,
                          @RequestHeader MultiValueMap<String, String> headerMap,
                          @RequestHeader("host") String host,
                          @CookieValue(value = "myCookie", required = false) String cookie
    ) {

        log.info("request={}", request);
        log.info("response={}", response);
        log.info("httpMethod={}", httpMethod);
        log.info("locale={}", locale);
        log.info("headerMap={}", headerMap);
        log.info("header host={}", host);
        log.info("myCookie={}", cookie);

        return "ok";
    }
}
```

- HttpServletRequest
- HttpServletResponse
- HttpMethod : HTTP 메서드를 조회한다. org.springframework.http.HttpMethod 
- Locale : Locale 정보를 조회한다.
- @RequestHeader MultiValueMap<String, String> headerMap
    - 모든 HTTP 헤더를 MultiValueMap 형식으로 조회한다. 
- @RequestHeader("host") String host
    - 특정 HTTP 헤더를 조회한다. 
    - 속성
        - 필수 값 여부: required
        - 기본 값 속성: defaultValue
- @CookieValue(value = "myCookie", required = false) String cookie
- 특정 쿠키를 조회한다. 
- 속성
    - 필수 값 여부: required 
    - 기본 값: defaultValue

![image](https://user-images.githubusercontent.com/69107255/116004830-8c2f6980-a63f-11eb-943d-bdbcb0b9b406.png)
