# View 분리 - v2
- 모든 컨트롤러에서 뷰로 이동하는 부분에 중복이 있고, 깔끔하지 않다.

```java
String viewPath = "/WEB-INF/views/new-form.jsp";
RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath); dispatcher.forward(request, response);
```

이 부분을 깔끔하게 분리하기 위해 별도로 뷰를 처리하는 객체를 만들자.

![image](https://user-images.githubusercontent.com/69107255/115228802-2f1e4a00-a14d-11eb-88e4-5ce2d3eb0870.png)

1. 클라이언트 
- 클라이언트가 HTTP요청을 한다.

2. Front-Controller
- Front-Controller라는 Servlet이 요청을 받는다.

3. 매핑 정보
- 클라이언트가 요청한 HTTP 요청에 url정보를 가지고 매핑 정보에는 Controller정보가 있다. 매핑 정보를 조회 후 어떤 Controller가 호출되어야 하는지 찾은 후 Controller를 호출한다.

4. Controller
- MyView라는 객체를 만들어서 Front-Controller로 반환한다.

5. MyView
- Front-Controller가 대신 MyView에 render()를 호출한다.

5. JSP
- 클라이언트에게 요청했던 HTML응 응답한다.

## MyView
뷰 객체는 이후 다른 버전에서도 함께 사용하므로 패키지 위치를 frontcontroller 에 두었다.

```java
    package hello.servlet.web.frontcontroller;  

    public class MyView {
        private String viewPath;

        public MyView(String viewPath) {
            this.viewPath = viewPath;
        }

        // view를 만드는 행위 자체를 렌더링한다라고 한다.
        public void render(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            RequestDispatcher dispatcher  = request.getRequestDispatcher(viewPath);
            dispatcher.forward(request,response);
        }

        public void render(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            modelToRequestAttribute(model, request);
            RequestDispatcher dispatcher  = request.getRequestDispatcher(viewPath);
            dispatcher.forward(request,response);
        }

        private void modelToRequestAttribute(Map<String, Object> model, HttpServletRequest request) {
            model.forEach((key, value) -> request.setAttribute(key,value));
        }
    }
```

## ControllerV2

```java
    public interface ControllerV2 {

        MyView process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;

    }
```

## MemberFormControllerV2 - 회원 등록 폼

- 이제 각 컨트롤러는 복잡한 dispatcher.forward() 를 직접 생성해서 호출하지 않아도 된다. 
- 단순히 MyView 객체를 생성하고 거기에 뷰 이름만 넣고 반환하면 된다. 
- ControllerV1 을 구현한 클래스와 ControllerV2 를 구현한 클래스를 비교해보면, 이 부분의 중복이 확실하게 제거된 것을 확인할 수 있다.


```java
    public class MemberFormControllerV2  implements ControllerV2 {
        @Override
        public MyView process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            return new MyView("/WEB-INF/views/new-form.jsp");
        }
    }
```

## MemberSaveControllerV2 - 회원 저장

```java
    public class MemberSaveControllerV2 implements ControllerV2 {

        private MemberRepository memberRepository = MemberRepository.getInstance();

        @Override
        public MyView process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

            String username = request.getParameter("username");
            int age = Integer.parseInt(request.getParameter("age"));

            Member member = new Member(username, age);
            memberRepository.save(member);

            //Model에 데이터를 보관한다.
            request.setAttribute("member",member);

            String viewPath = "/WEB-INF/views/save-result.jsp";

            RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath);
            dispatcher.forward(request,response);

            return new MyView("/WEB-INF/views/save-result.jsp");
        }
    }
```

## 프론트 컨트롤러 V2

```java
    @WebServlet(name = "frontControllerServletV2", urlPatterns = "/front-controller/v2/*")
    public class FrontControllerServletV2 extends HttpServlet {
        // 매핑 정보        
        private Map<String, ControllerV2> controllerMap = new HashMap<>();

        // 생성자에 생성 될 때 실행 될 수 있도록 매핑 정보를 담아 놓는다.
        public FrontControllerServletV2() {
            controllerMap.put("/front-controller/v2/members/new-form",new MemberFormControllerV2());
            controllerMap.put("/front-controller/v2/members/save",new MemberSaveControllerV2());
            controllerMap.put("/front-controller/v2/members",new MemberListControllerV2());
        }

        @Override
        protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

            // 로거로 찍는게 좋지만 sout으로 검증해본다.
            // http://localhost:8080/front-controller/v2/* 로 요청 시 잘 호출이 잘 되는지 확인을 해봐야한다.
            System.out.println("FrontControllerServletV2.service");

            // controllerV1Map에 있는 key값이 requestURI에 저장된다.
            String requestURI = request.getRequestURI();

            // controllerV1Map에 인스턴스 주소가 controller애 저장된다. 
            // IS-A관계
            // ex) ControllerV2 controller = new MemberFormControllerV2();
            ControllerV2 controller = controllerMap.get(requestURI);

            // 만약 등록 된 controller가 없다면 즉 null일 경우 404 페이지
            if(controller == null){
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // 인스턴스에 주소가 view에 저장된다
            // ex) MyView view = new MyView("/WEB-INF/views/new-form.jsp");
            MyView view = controller.process(request, response);
            
            // Myview에 생성자를 확인하면 viewpath가 이미 위에 view객체에 의해 초기화 되어 있고,
            // request.getRequestDispatcher(viewPath);에 경로가 들어가고 forward하게된다.
            view.render(request,response);
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
│       ├─📄Myview.java
│       └─📁v2
│          ├─📄ControllerV1.java
│          └─📄FrontControllerServletV2.java
│          ├─📁controller
│          ├─📄ControllerV2.java
│          ├─📄MemberSaveControllerV2.java
│          ├─📄MemberListControllerV2.java
├── 📁WEB-INF
│   └─📁views
      └─📄ControllerV1
```