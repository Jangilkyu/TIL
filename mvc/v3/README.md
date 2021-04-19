# Model 추가 - v3

## 서블릿 종속성 제거
컨트롤러 입장에서 HttpServletRequest, HttpServletResponse이 꼭 필요할까?
요청 파라미터 정보는 자바의 Map으로 대신 넘기도록 하면 지금 구조에서는 컨트롤러가 서블릿 기술을 몰라도 동작할 수 있다.
그리고 request 객체를 Model로 사용하는 대신에 별도의 Model 객체를 만들어서 반환하면 된다. 우리가 구현하는 컨트롤러가 서블릿 기술을 전혀 사용하지 않도록 변경해보자.
이렇게 하면 구현 코드도 매우 단순해지고, 테스트 코드 작성이 쉽다.

## 뷰 이름 중복 제거
컨트롤러에서 지정하는 뷰 이름에 중복이 있는 것을 확인할 수 있다.
컨트롤러는 뷰의 `논리 이름`을 반환하고, `실제 물리 위치의 이름`은 **프론트 컨트롤러**에서 처리하도록 단순화 하자.
이렇게 해두면 향후 뷰의 폴더 위치가 함께 이동해도 프론트 컨트롤러만 고치면 된다.

ex) `/WEB-INF/views/new-form.jsp` -> `new-form`


![image](https://user-images.githubusercontent.com/69107255/115255232-0310c200-a169-11eb-8a4b-f11fbe4fbf1a.png)

## ModelView

뷰의 이름과 뷰를 렌더링할 때 필요한 model 객체를 가지고 있다. model은 단순히 map으로 되어 있으므로 컨트롤러에서 뷰에 필요한 데이터를 key, value로 넣어주면 된다.

```java
    package hello.servlet.web.frontcontroller;

    import java.util.HashMap;
    import java.util.Map;

    public class ModelView {
        private String viewName;
        private Map<String, Object> model = new HashMap<>();

        public ModelView(String viewName) {
            this.viewName = viewName;
        }

        public String getViewName() {
            return viewName;
        }

        public void setViewName(String viewName) {
            this.viewName = viewName;
        }

        public Map<String, Object> getModel() {
            return model;
        }

        public void setModel(Map<String, Object> model) {
            this.model = model;
        }
    }    
```

## ControllerV3

ControllerV3 서블릿 기술을 전혀 사용하지 않는다. 따라서 구현이 매우 단순해지고, 테스트 코드 작성시 테스트 하기 쉽다.
HttpServletRequest가 제공하는 파라미터는 프론트 컨트롤러가 paramMap에 담아서 호출해주면 된다. 응답 결과로 뷰 이름과 뷰에 전달할 Model 데이터를 포함하는 ModelView 객체를 반환하면 된다.

```java
    public interface ControllerV3 {

        ModelView process(Map<String,String> paramMap);
    }
```

## MyView
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

## MemberFormControllerV3 - 회원 등록 폼

- view 전체 path 이름을 넣는것이 아닌 논리적인 이름만 ModelView에 넣는다.

```java
    public class MemberFormControllerV3 implements ControllerV3 {

        private MemberRepository memberRepository = MemberRepository.getInstance();

        @Override
        public ModelView process(Map<String, String> paramMap) {
            return new ModelView("new-form");
        }
    }
```

```java
    public class MemberSaveControllerV3 implements ControllerV3 {

        private MemberRepository memberRepository = MemberRepository.getInstance();

        @Override
        public ModelView process(Map<String, String> paramMap) {
            String username = paramMap.get("username");
            int age = Integer.parseInt(paramMap.get("age"));

            Member member = new Member(username, age);
            Member save = memberRepository.save(member);

            ModelView mv = new ModelView("save-result");
            mv.getModel().put("member",member);
            return mv;
        }
    }
```

## MemberSaveControllerV3 - 회원 저장

```java
    public class MemberSaveControllerV3 implements ControllerV3 {

        private MemberRepository memberRepository = MemberRepository.getInstance();

        @Override
        public ModelView process(Map<String, String> paramMap) {
            // 파라미터 정보는 map에 담겨있다. map에서 필요한 요청 파라미터를 조회하면 된다.
            String username = paramMap.get("username");
            int age = Integer.parseInt(paramMap.get("age"));

            Member member = new Member(username, age);
            Member save = memberRepository.save(member);

            ModelView mv = new ModelView("save-result");
            // 모델은 단순한 map이므로 모델에 뷰에서 필요한 member 객체를 담고 반환한다.
            mv.getModel().put("member",member);
            return mv;
        }
    }
```

```java
    @WebServlet(name = "frontControllerServletV3", urlPatterns = "/front-controller/v3/*")
    public class FrontControllerServletV3 extends HttpServlet {
        // 매핑 정보        
        private Map<String, ControllerV3> controllerMap = new HashMap<>();
        
        // 생성자에 생성 될 때 실행 될 수 있도록 매핑 정보를 담아 놓는다.
        public FrontControllerServletV3() {
            controllerMap.put("/front-controller/v3/members/new-form",new MemberFormControllerV3());
            controllerMap.put("/front-controller/v3/members/save",new MemberSaveControllerV3());
            controllerMap.put("/front-controller/v3/members",new MemberListControllerV3());
        }

        @Override
        protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            System.out.println("FrontControllerServletV3.service");
            
            String requestURI = request.getRequestURI();
            System.out.println("요청 된 uri : "+requestURI);

            ControllerV3 controller = controllerMap.get(requestURI);

            if(controller == null){
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // paramMap
            Map<String, String> paramMap = createParamMap(request);

            ModelView mv = controller.process(paramMap);
            String viewName = mv.getViewName();// 논리이름

            // 1.논리이름(예를들어 new-form)가 viewResolver메소드로 넘어간다.
            // 2. view에 new MyView("/WEB-INF/views/" + viewName + ".jsp");생성 된 인스턴스에 주소가 담긴다.
            MyView view = viewResolver(viewName);

            view.render(mv.getModel(),request,response);
        }

        private MyView viewResolver(String viewName) {
            return new MyView("/WEB-INF/views/" + viewName + ".jsp");
        }

        private Map<String, String> createParamMap(HttpServletRequest request) {
            Map<String,String> paramMap = new HashMap<>();
            // 전체 파라미터 조회
            // request.getParameterNames() 즉, 쿼리스트링에 클라이언트가 서버로 입력한 값들을 asIterator를 통해 전부 paramMap에 put한 후 리턴
            request.getParameterNames().asIterator()
                    .forEachRemaining(paramName -> paramMap.put(paramName, request.getParameter(paramName)));
                    return paramMap;
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
│       └─📁v3
│          ├─📄ControllerV3.java
│          └─📄FrontControllerServletV3.java
│          ├─📁controller
│          ├─📄ControllerV3.java
│          ├─📄MemberSaveControllerV3.java
│          ├─📄MemberListControllerV3.java
├── 📁WEB-INF
│   └─📁views
      └─📄ControllerV3
```