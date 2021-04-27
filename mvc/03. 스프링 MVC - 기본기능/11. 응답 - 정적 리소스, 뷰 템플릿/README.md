
# HTTP 응답 - 정적 리소스, 뷰 템플릿

응답 데이터는 이미 앞에서 일부 다룬 내용들이지만, 응답 부분에 초점을 맞추어서 정리해보자.
스프링(서버)에서 응답 데이터를 만드는 방법은 크게 3가지이다.

- 정적 리소스
    - 예) 웹 브라우저에 정적인 HTML, css, js을 제공할 때는, 정적 리소스를 사용한다.
- 뷰 템플릿 사용
    - 예) 웹 브라우저에 동적인 HTML을 제공할 때는 뷰 템플릿을 사용한다.
- HTTP 메시지 사용
    - HTTP API를 제공하는 경우에는 HTML이 아니라 데이터를 전달해야 하므로, HTTP 메시지 바디에 JSON 같은 형식으로 데이터를 실어 보낸다.


## 정적 리소스 경로
`src/main/resources/static`

1. 다음과 같이 다음 경로에 파일이 들어있으면
`src/main/resources/static/basic/hello-form.html`

2. 웹 브라우저에서 다음과 같이 실행하면 된다. 👉 `http://localhost:8080/basic/hello-form.html`

정적 리소스는 해당 파일을 변경 없이 그대로 서비스하는 것이다.


## 뷰 템플릿
뷰 템플릿을 거쳐서 HTML이 생성되고, 뷰가 응답을 만들어서 전달한다.
일반적으로 HTML을 동적으로 생성하는 용도로 사용하지만, 다른 것들도 가능하다. 뷰 템플릿이 만들 수 있는 것이라면 뭐든지 가능하다.
스프링 부트는 기본 뷰 템플릿 경로를 제공한다.

**뷰 템플릿 경로**
`src/main/resources/templates`

**뷰 템플릿 생성**
- `src/main/resources/templates/response/hello.html`
- p태그에 `th:text="${data}"` 부분을 렌더링 시 클라이언트가 요청한 값으로 변경한다.

```html
    <!DOCTYPE html>
    <html xmlns:th="http://www.thymeleaf.org"> <head>
    <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
    <p th:text="${data}">empty</p>
    </body>
    </html>
```

## ResponseViewController - 뷰 템플릿을 호출하는 컨트롤러

```java
@Controller
public class ResponseViewController {

    @RequestMapping("/response-view-v1")
    public ModelAndView responseViewV1() {
        ModelAndView mav = new ModelAndView("response/hello")
                .addObject("data", "hello!");
        return mav;
    }
}
```

## String을 반환하는 경우 - View or HTTP 메시지

- `@ResponseBody` 가 없으면 `response/hello` 로 뷰 리졸버가 실행되어서 뷰를 찾고, 렌더링 한다.
- `@ResponseBody` 가 있으면 뷰 리졸버를 실행하지 않고, HTTP 메시지 바디에 직접 `response/hello` 라는 문자가 입력된다.

여기서는 뷰의 논리 이름인 `response/hello` 를 반환하면 다음 경로의 뷰 템플릿이 렌더링 되는 것을 확인할 수 있다.

실행 : `templates/response/hello.html`

- **Void**를 반환하는 경우 

- 주의 !! **참고로 이 방식은 명시성이 너무 떨어지고 이렇게 딱 맞는 경우도 많이 없어서, 권장하지 않는다.**

`@Controller` 를 사용하고, `HttpServletResponse` , `OutputStream(Writer)` 같은 HTTP 메시지
바디를 처리하는 파라미터가 없으면 요청 URL을 참고해서 논리 뷰 이름으로 사용 
요청 URL: `/response/hello`
실행: `templates/response/hello.html`


## Thymeleaf 스프링 부트 설정

스프링 부트가 자동으로 `ThymeleafViewResolver` 와 필요한 스프링 빈들을 등록한다. 그리고 다음 설정도 사용한다. 이 설정은 기본 값 이기 때문에 변경이 필요할 때만 설정하면 된다.

build.gradle
```
    `implementation 'org.springframework.boot:spring-boot-starter-thymeleaf'`
```

## application.properties
```
    spring.thymeleaf.prefix=classpath:/templates/ spring.thymeleaf.suffix=.html
```