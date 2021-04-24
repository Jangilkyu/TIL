## **OldController**

```java
/**
 * url이 호출되면 Http요청이 들어간다.
 * Handler-Mapping에서 Controller를 찾아와야 한다.
 * Handler-Adapter를 통해 해당 콘트롤러를 실행할 수 있는지 검증해야한다.SimpleControllerHandlerAdapter
 */

// spring bean에 이름
@Component("/springmvc/old-controller")
public class OldController implements Controller {

    @Override
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println("OldController.handleRequest");

        return new ModelAndView("new-form");
    }
}
```
### **실행**

1. `http://localhost:8080/springmvc/old-controller`에서 `springmvc/old-controller`Controller를 어떻게 호출할 수 있을까?

2가지 방법이 있다.

- **HandlerMapping(핸들러 매핑)**
    - 핸들러 매핑에서 이 컨트롤러를 찾을 수 있어야 한다.
    - 예) **스프링 빈의 이름으로 핸들러를 찾을 수 있는 핸들러 매핑**이 필요하다.
    - 위에 **스프링 빈의 이름**이란 `springmvc/old-controller`을 의미한다.
- **HandlerAdapter(핸들러 어댑터)**
    - 핸들러 매핑을 통해서 찾은 핸들러를 실행할 수 있는 핸들러 어댑터가 필요하다.
    - 예) `Controller` 인터페이스를 실행할 수 있는 핸들러 어댑터를 찾고 실행해야 한다.

`핸들러 매핑`도, `핸들러 어댑터`도 모두 순서대로 찾고 만약 없으면 다음 순서로 넘어간다.

## **HandlerMapping**

```
0순위 RequestMappingHandlerMapping : 애노테이션 기반의 컨트롤러인 @RequestMapping에서 사용
1순위 BeanNameUrlHandlerMapping : 스프링 빈의 이름으로 핸들러를 찾는다.
```

### **1. 핸들러 매핑으로 핸들러 조회**

1. HandlerMapping 을 순서대로 실행해서, 핸들러를 찾는다.
    - RequestMappingHandlerMapping는 `@RequestMapping` @(애노테이션이)이 있는 경우에 실행된다.
    - BeanNameUrlHandlerMapping  Spring bean에 역할을 하는`@Component`가 있을 경우에 실행된다.
2. 이 경우 빈 이름으로 핸들러를 찾아야 하기 때문에 이름 그대로 빈 이름으로 핸들러를 찾아주는 `BeanNameUrlHandlerMapping`가 실행에 성공하고 핸들러인 `OldController`를 반환한다.

## **HandlerAdapter**

```
0순위 RequestMappingHandlerAdapter : 애노테이션 기반의 컨트롤러인 @RequestMapping에서 사용
1순위 HttpRequestHandlerAdapter : HttpRequestHandler 처리
2순위 SimpleControllerHandlerAdapter : Controller 인터페이스(애노테이션X, 과거에 사용) 처리
```

### **2.핸들러 어댑터 조회**
1. `HandlerAdapter` 의 `supports()` 를 순서대로 호출한다. 
2. `SimpleControllerHandlerAdapter` 가 `Controller 인터페이스를 지원`하므로 대상이 된다.

우리가 설계한 `OldController`는 `Controller인터페이스를` 구현하고 있다.
핸들러 어댑터조회에서 `SimpleControllerHandlerAdapter`에서 아래 그림 `supports(Object handler)`메소드를 통해 Controller를 참조하고 있는 컨트롤러 인지 검증한다.

![image](https://user-images.githubusercontent.com/69107255/115749753-62253f80-a3d2-11eb-9668-f1ab1afbea1c.png)

### 3. 핸들러 어댑터 실행

1. 디스패처 서블릿이 조회한 `SimpleControllerHandlerAdapter` 를 실행하면서 핸들러 정보도 함께 넘겨준다.
2. `SimpleControllerHandlerAdapter` 는 핸들러인 `OldController` 를 내부에서 실행하고, 그 결과를 반환한다.

`DispatcherServlet`이 조회한 `SimpleControllerHandlerAdapter`에 대한 `handle()`메소드를 실행하게 된다.

`OldController`에 있는 Override된 handleRequest가 실행된다.

![image](https://user-images.githubusercontent.com/69107255/115949046-10350480-a50d-11eb-95f6-bfe45fc252af.png)

## 정리 OldController 핸들러매핑, 어댑터 

`OldController` 를 실행하면서 사용된 객체는 다음과 같다.
HandlerMapping = BeanNameUrlHandlerMapping
HandlerAdapter = SimpleControllerHandlerAdapter

# HttpRequestHandler

- 목표
    - 이번에는 핸들러 매핑으로 핸들러 조회 시 1순위인 `HttpRequestHandlerAdapter`를 통해 HttpRequestHandler를 처리하는 법을 알아보자

핸들러 매핑과, 어댑터를 더 잘 이해하기 위해 Controller 인터페이스가 아닌 다른 핸들러를 알아보자. `HttpRequestHandler` 핸들러(컨트롤러)는 `서블릿과 가장 유사한 형태`의 핸들러이다.

```java
    /*
    핸들러 매핑과, 어댑터를 더 잘 이해하기 위해 Controller 인터페이스가 아닌 다른 핸들러를 알아보자. HttpRequestHandler 핸들러(컨트롤러)는 서블릿과 가장 유사한 형태의 핸들러이다.
    */
    @FunctionalInterface
    public interface HttpRequestHandler {
        void handleRequest(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException;

    }
```

## MyHttpRequestHandler

`HttpRequestHandler`인터페이스를 구현한 `MyHttpRequestHandler`인터페이스를 ㅈ
```java
    package hello.servlet.web.springmvc.old;

    import org.springframework.stereotype.Component;
    import org.springframework.web.HttpRequestHandler;

    import javax.servlet.ServletException;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;
    import java.io.IOException;

    @Component("/springmvc/request-handler")
    public class MyHttpRequestHandler implements HttpRequestHandler {

        @Override
        public void handleRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            System.out.println("MyHttpRequestHandler.handleRequest");
        }
    }
```

## **실행**

### 1. 핸들러 매핑으로 핸들러 조회
1. HandlerMapping 을 순서대로 실행해서, 핸들러를 찾는다

2. 이 경우 **빈 이름으로 핸들러를 찾아야하기 때문에 이름 그대로 빈 이름으로 핸들러를 찾아주는** `BeanNameUrlHandlerMapping` 가 실행에 성공하고 핸들러인 `MyHttpRequestHandler` 를 반환한다.

### 2. 핸들러 어댑터 조회

1. `HandlerAdapter` 의 `supports()` 를 순서대로 호출한다.
2. `HttpRequestHandlerAdapter` 가 `HttpRequestHandler 인터페이스`를 지원하므로 대상이 된다.

### 3. 핸들러 어댑터 실행
1. 디스패처 서블릿이 조회한 `HttpRequestHandlerAdapter` 를 실행하면서 핸들러 정보도 함께 넘겨준다.
2. `HttpRequestHandlerAdapter` 는 핸들러인 `MyHttpRequestHandler` 를 내부에서 실행하고, 그 결과를 반환한다.

### 정리 - MyHttpRequestHandler 핸들러매핑, 어댑터 

MyHttpRequestHandler 를 실행하면서 사용된 객체는 다음과 같다.
HandlerMapping = BeanNameUrlHandlerMapping
HandlerAdapter = HttpRequestHandlerAdapter