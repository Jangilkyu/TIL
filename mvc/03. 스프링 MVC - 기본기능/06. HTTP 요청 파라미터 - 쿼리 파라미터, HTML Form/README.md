# HTTP 요청 파라미터 - 쿼리 파라미터, HTML Form

## HTTP 요청 데이터 조회 - 개요
서블릿에서 학습했던 HTTP 요청 데이터를 조회 하는 방법을 다시 떠올려보자. 그리고 서블릿으로 학습했던 내용을 스프링이 얼마나 깔끔하고 효율적으로 바꾸어주는지 알아보자.
HTTP 요청 메시지를 통해 클라이언트에서 서버로 데이터를 전달하는 방법을 알아보자.

`클라이언트에서 서버로 요청 데이터를 전달할 때는 주로 다음 3가지 방법을 사용한다. `
- **GET - 쿼리 파라미터**
    - /url?username=hello&age=20
    - 메시지 바디 없이, URL의 쿼리 파라미터에 데이터를 포함해서 전달 
    - 예) 검색, 필터, 페이징등에서 많이 사용하는 방식
- **POST - HTML Form**
    - content-type: application/x-www-form-urlencoded
    - 메시지 바디에 쿼리 파리미터 형식으로 전달 username=hello&age=20 
    - 예) 회원 가입, 상품 주문, HTML Form 사용
- **`HTTP message body`에 데이터를 직접 담아서 요청**
    - HTTP API에서 주로 사용, JSON, XML, TEXT 
    - 데이터 형식은 주로 JSON 사용
    - POST, PUT, PATCH

## RequestParamController
```java
    @Slf4j
    @Controller
    public class RequestParamController {

        @RequestMapping("/request-param-v1")
        public void requestParamV1(HttpServletRequest request, HttpServletResponse response) throws IOException {
            // 클라이언트가 요청한 값 request객체에 getParameter메소드를 통해서 받는다.
            String username = request.getParameter("username");
            int age = Integer.parseInt(request.getParameter("age"));
            // log에 info메소드를 통해서 값을 출력
            log.info("username = {}, age={}",username,age);

            response.getWriter().write("ok");

        }
    }
```


## hello-form.html

- 테스트용 HTML Form
- 리소스는 `/resources/static` 아래에 두면 스프링 부트가 자동으로 인식한다.
- > Jar 를 사용하면 `webapp 경로`를 사용할 수 없다. 이제부터 정적 리소스도 클래스 경로에 함께 포함해야 한다.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<form action="/request-param-v1" method="post">
    username: <input type="text" name="username"/>
    age: <input type="text" name="age"/>
    <button type="submit">전송</button>
</form>
</body>
</html>
```

![image](https://user-images.githubusercontent.com/69107255/116041544-48247f00-a6a8-11eb-8f23-eb7286416bf1.png)


request.getParameter()통해 HttpServletRequest가 제공하는 방식으로 요청 파라미터를 조회했다.

아래 이미지와 같이 `jang`과 `29`과 로그로 출력된 것을 확인할 수 있다.

![image](https://user-images.githubusercontent.com/69107255/116041015-abfa7800-a6a7-11eb-9823-f3ece98865e2.png)
