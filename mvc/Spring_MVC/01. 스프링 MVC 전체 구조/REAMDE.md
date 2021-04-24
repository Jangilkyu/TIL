# 스프링 MVC 전체 구조

`직접 만든 MVC 프레임워크`와 `스프링 MVC`를 비교해보자.

## 직접 만든 MVC 프레임워크 구조

![image](https://user-images.githubusercontent.com/69107255/115394086-5e03f100-a21d-11eb-9b3f-ce92210eab69.png)

## SpringMVC 구조

![image](https://user-images.githubusercontent.com/69107255/115393976-43317c80-a21d-11eb-8ec9-6844e2e54543.png)

## 직접 만든 프레임워크 스프링 MVC 비교 
- FrontController 👉 DispatcherServlet 
- handlerMappingMap 👉 HandlerMapping 
- MyHandlerAdapter 👉 HandlerAdapter 
- ModelView 👉 ModelAndView 
- viewResolver 👉 ViewResolver
- MyView 👉 View

## DispatcherServlet

- `DispacherServlet` 도 부모 클래스에서 `HttpServlet` 을 상속 받아서 사용하고, 서블릿으로 동작한다.
    - DispatcherServlet 👉 FrameworkServlet 👉 HttpServletBean 👉 HttpServlet
- 스프링 부트는 `DispacherServlet` 을 서블릿으로 자동으로 등록하면서 **모든 경로( urlPatterns="/" )**에 대해서 매핑한다.

## **DispatcherServlet 구조 살펴보기**

`org.springframework.web.servlet.DispatcherServlet`

- 스프링 MVC도 프론트 컨트롤러 패턴으로 구현되어 있다.
- 스프링 MVC의 프론트 컨트롤러가 바로 디스패처 서블릿(DispatcherServlet)이다. 그리고 이 디스패처 서블릿이 바로 스프링 MVC의 핵심이다.

![image](https://user-images.githubusercontent.com/69107255/115395935-65c49500-a21f-11eb-802a-488104159c8f.png)

### 🤜 **요청 흐름**

- 서블릿이 호출되면 `HttpServlet` 이 제공하는 `serivce()` 가 호출된다.
- 스프링 MVC는 `DispatcherServlet` 의 부모인 `FrameworkServlet` 에서 `service()` 를 오버라이드 해두었다.
- `FrameworkServlet.service()` 를 시작으로 여러 메서드가 호출되면서 `DispacherServlet.doDispatch()` 가 호출된다.

## DispacherServlet.doDispatch()

지금부터 `DispacherServlet` 의 핵심인 `doDispatch()` 코드를 분석해보자.

```java
    protected void doDispatch(HttpServletRequest request, HttpServletResponse
    response) throws Exception {
        HttpServletRequest processedRequest = request;
        HandlerExecutionChain mappedHandler = null;
        ModelAndView mv = null;
    // 1. 핸들러 조회
    mappedHandler = getHandler(processedRequest); if (mappedHandler == null) {
       noHandlerFound(processedRequest, response);
    return; 
    }

    //2.핸들러 어댑터 조회-핸들러를 처리할 수 있는 어댑터
    HandlerAdapter ha = getHandlerAdapter(mappedHandler.getHandler());

    // 3. 핸들러 어댑터 실행 -> 4. 핸들러 어댑터를 통해 핸들러 실행 -> 5. ModelAndView 반환 
    mv = ha.handle(processedRequest, response, mappedHandler.getHandler());
    
    processDispatchResult(processedRequest, response, mappedHandler, mv, dispatchException);
    }
    private void processDispatchResult(HttpServletRequest request, HttpServletResponse response, HandlerExecutionChain mappedHandler, ModelAndView mv, Exception exception) throws Exception{
    // 뷰 렌더링 호출
    render(mv, request, response);
    }
    protected void render(ModelAndView mv, HttpServletRequest request, HttpServletResponse response) throws Exception {
    
    View view;
    String viewName = mv.getViewName(); 
    //6. 뷰 리졸버를 통해서 뷰 찾기,7.View 반환
    view = resolveViewName(viewName, mv.getModelInternal(), locale, request);
    // 8. 뷰 렌더링
    view.render(mv.getModelInternal(), request, response); }
```

### 동작 순서

1. 핸들러 조회: 핸들러 매핑을 통해 요청 URL에 매핑된 핸들러(컨트롤러)를 조회한다.
2. 핸들러 어댑터 조회: 핸들러를 실행할 수 있는 핸들러 어댑터를 조회한다.
3. 핸들러 어댑터 실행: 핸들러 어댑터를 실행한다.
4. 핸들러 실행: 핸들러 어댑터가 실제 핸들러를 실행한다.
5. ModelAndView 반환: 핸들러 어댑터는 핸들러가 반환하는 정보를 ModelAndView로 변환해서 반환한다.
6. viewResolver 호출: 뷰 리졸버를 찾고 실행한다.
    - JSP의 경우: InternalResourceViewResolvers가 자동 등록되고, 사용된다.
7. View반환:뷰리졸버는뷰의논리이름을물리이름으로바꾸고,렌더링 역할을 담당하는 뷰 객체를 반환한다.
    - JSP의 경우 InternalResourceView(JstlView) 를 반환하는데, 내부에 forward() 로직이 있다.
8. 뷰렌더링:뷰를통해서뷰를렌더링한다.