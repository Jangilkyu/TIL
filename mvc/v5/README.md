# 유연한 컨트롤러1 - v5

만약 어떤 개발자는 ControllerV3 방식으로 개발하고 싶고, 어떤 개발자는 ControllerV4 방식으로
개발하고 싶다면 어떻게 해야할까?

## 어댑터 패턴
지금까지 우리가 개발한 프론트 컨트롤러는 한가지 방식의 컨트롤러 인터페이스만 사용할 수 있다. <br>
`ControllerV3` , `ControllerV4` 는 완전히 다른 인터페이스이다. 따라서 **호환이 불가능**하다. 마치 v3는 110v이고, v4는 220v 전기 콘센트 같은 것이다. 이럴 때 사용하는 것이 바로 어댑터이다.<br>
**어댑터 패턴**을 사용해서 **프론트 컨트롤러**가 다양한 방식의 컨트롤러를 처리할 수 있도록 변경해보자<br>

```java
    public interface ControllerV3 {
            ModelView process(Map<String, String> paramMap);
    }
```

```java
    public interface ControllerV3 {
            ModelView process(Map<String, String> paramMap);
    }
```

## V5 구조

![image](https://user-images.githubusercontent.com/69107255/115355331-87a92200-a1f5-11eb-9b12-4dcdf746889f.png)

1. 클라이언트 
- 클라이언트가 HTTP요청을 한다.

2. Front-Controller
- Front-Controller라는 Servlet이 요청을 받는다.

3. 매핑 정보
- 클라이언트가 요청한 HTTP 요청에 url정보를 가지고 매핑 정보에는 Controller정보가 있다. 매핑 정보를 조회 후 어떤 Controller가 호출되어야 하는지 찾은 후 Controller를 호출한다.

4. 핸들러 어댑터 목록
- 핸들러를 처리할 수 있는 핸들러 어댑터를 조회한다.

4. Controller
- MyView라는 객체를 만들어서 Front-Controller로 반환한다.

5. MyView
- Front-Controller가 대신 MyView에 render()를 호출한다.

5. JSP
- 클라이언트에게 요청했던 HTML응 응답한다.

## MyHandlerAdapter

- 어댑터는 이렇게 구현해야 한다는 **어댑터용 인터페이스**이다.

```java
    public interface MyHandlerAdapter {
        //어댑터가 해당 컨트롤러를 처리할 수 있는지 판단하는 메서드다.
        boolean supports(Object handler);
        //
        ModelView handle(HttpServletRequest request, HttpServletResponse response,
    Object handler) throws ServletException, IOException;
    }
```

## ControllerV3HandlerAdapter - V3어댑터

```java
    public class ControllerV3HandlerAdapter implements MyHandlerAdapter {
        // ControllerV3를 처리할 수 있는 어댑터를 뜻한다.
        @Override
        public boolean supports(Object handler) {
            // ControllerV3만 지원되어야 하기 때문에 instanceof연산자를 통해 객체에 타입을 확인한다.
            return (handler instanceof ControllerV3);
        }

        @Override
        public ModelView handle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException, IOException {
            // Object타입인 handler를 ControllerV3 타입으로 다운 캐스팅 해준다.
            ControllerV3 controller = (ControllerV3) handler;
            // paramMap에는 쿼리스트링 즉, 클라이언트가 입력한 input값들이  paramMap에 key,value로 담긴다.
            // ex) paramMap = {age=19, username=jang}
            Map<String, String> paramMap = createParamMap(request);
            ModelView mv = controller.process(paramMap);

            return mv;
        }

        private Map<String, String> createParamMap(HttpServletRequest request) {
            Map<String,String> paramMap = new HashMap<>();
            request.getParameterNames().asIterator()
                    .forEachRemaining(paramName -> paramMap.put(paramName, request.getParameter(paramName)));
            return paramMap;
        }
    }
```

## FrontControllerServletV5

```java
    @WebServlet(name="frontControllerServletV5",urlPatterns = "/front-controller/v5/*")
    public class FrontControllerServletV5 extends HttpServlet {
        // handlerMappingMap에 타입이 <String,Object> 즉, Object타입이므로 유연하게 ControllerV3, ControllerV4 등이 들어갈 수 있다.
        private final Map<String,Object> handlerMappingMap = new HashMap<>();
        // IS-A관계를 통해 부모 자식관계 인터페이스인 MyHandlerAdapter로 구현 된 모든 객체를 List에 담는다.
        private final List<MyHandlerAdapter> handlerAdapters = new ArrayList<>();

        // FrontControllerServletV5 생성자

        public FrontControllerServletV5() {
            // 맵핑 정보를 초기화하는 메소드
            //핸들러 매핑 초기화
            initHandlerMappingMap();
            //핸들러 매핑 초기화
            initHandlerAdapters();
        }

        // 맵핑 정보를 초기화하는 메소드
        private void initHandlerMappingMap() {
            // v3 추가
            handlerMappingMap.put("/front-controller/v5/v3/members/new-form",new MemberFormControllerV3());
            handlerMappingMap.put("/front-controller/v5/v3/members/save",new MemberSaveControllerV3());
            handlerMappingMap.put("/front-controller/v5/v3/members",new MemberListControllerV3());

            // v4 추가
            handlerMappingMap.put("/front-controller/v5/v4/members/new-form",new MemberFormControllerV4());
            handlerMappingMap.put("/front-controller/v5/v4/members/save",new MemberSaveControllerV4());
            handlerMappingMap.put("/front-controller/v5/v4/members",new MemberListControllerV4());

        }

        // 
        private void initHandlerAdapters() {
            handlerAdapters.add(new ControllerV3HandlerAdapter());
            handlerAdapters.add(new ControllerV4HandlerAdapter());
        }

        @Override
        protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // request정보를 getHandler 메소드로 호출한다.
            // 클라이언트가 요청한 uri 객체 주소를 담은 handler가 Object타입으로 리턴된다.
            // 좌항 handler에 리턴된 객체에 주소를 담는다. 
            Object handler = getHandler(request);
            
            // 만약 존재하지 않는 주소라면 즉, 주소가 안담겨 있을 경우
            if(handler == null){
                // 404
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            // getHandlerAdapter메소드에 handler를 인자로 하여 전달 한다.
            MyHandlerAdapter adapter = getHandlerAdapter(handler);
            // 
            ModelView mv = adapter.handle(request, response, handler);
            // 논리 이름을 viewName에 저장한다.
            String viewName = mv.getViewName();
            // 
            MyView view = viewResolver(viewName);
            
            view.render(mv.getModel(),request,response);
        }

        // 
        private MyHandlerAdapter getHandlerAdapter(Object handler) {
            for (MyHandlerAdapter adapter : handlerAdapters) {
                // 만약 adapter가 handler를 지원하는가 ?
                // 클라이언트가 요청한 uri객체 주소가 담겨 있는 handler를 ControllerVXHandlerAdapter에 supports메소드를 호출해서 ControllerVX를 처리할 수 있는 어댑터인지 확인
                if(adapter.supports(handler)){
                    // 클라이언트가 요청한 uri 인스턴스에 일치하는 어댑터에 주소를 리턴한다.
                    return  adapter;
                }
            }
            throw new IllegalArgumentException("handler adapter를 찾을 수 없습니다." + handler);
        }

        private Object getHandler(HttpServletRequest request) {
            // 클라이언트가 요청한 경로 이름이 requestURI에 저장된다.
            String requestURI = request.getRequestURI();
            // handlerMappingMap에 클라이언트가 요청한 requestURI와 동일한 key값이 있는지 확인 후 handler에 넣는다.
            // 그 객체를 IS-A 관계로 Object타입 인스턴스에 넣는다.
            Object handler = handlerMappingMap.get(requestURI);
            
            return handler;
        }

        private MyView viewResolver(String viewName) {
            return new MyView("/WEB-INF/views/" + viewName + ".jsp");
        }

    }
```

## 디렉토리 구조

```
📁servlet
├📁src/main/java
├── 📁hello
│   ├─📁servlet
│   └─📁web
│     └─📁frontcontroller
│       ├─📄ModelView.java
│       ├─📄MyView.java
│       └─📁v5
│         └─📁adapter
│          ├─📄ControllerV3HandlerAdapter.java
│       ├─📄ControllerV3.java
│       ├─📄MemberSaveControllerV3.java
│          ├─📄MemberListControllerV3.java
├── 📁WEB-INF
│   └─📁views
│     ├─📄members.jsp
│     ├─📄new-form.jsp
│     └─📄save-result.jsp
```