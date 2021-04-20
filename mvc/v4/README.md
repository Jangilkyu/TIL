# 단순하고 실용적인 컨트롤러 - v4

## 목표

앞서 만든 v3 컨트롤러는 서블릿 종속성을 제거하고 뷰 경로의 중복을 제거하는 등, 잘 설계된 컨트롤러이다. <br>
그런데 실제 컨트톨러 인터페이스를 구현하는 개발자 입장에서 보면, 항상 ModelView 객체를 생성하고 반환해야 하는 부분이 조금은 번거롭다.<br>
좋은 프레임워크는 아키텍처도 중요하지만, 그와 더불어 실제 개발하는 개발자가 단순하고 편리하게 사용할 수 있어야 한다. 소위 실용성이 있어야 한다.<br>
이번에는 v3를 조금 변경해서 실제 구현하는 개발자들이 매우 편리하게 개발할 수 있는 v4 버전을 개발해보자.<br>

![image](https://user-images.githubusercontent.com/69107255/115289176-411fdd00-a18d-11eb-8cd8-f8cf24e632e8.png)

## ControllerV4

이번 버전은 인터페이스에 ModelView가 없다.
model 객체는 파라미터로 전달되기 때문에 그냥 사용하면 되고, 결과로 뷰의 이름만 반환해주면 된다.

```java
    public interface ControllerV4 {
        /**
        *
        * @param paramMap
        * @param model
        * @return viewName
        */
        String process(Map<String,String> paramMap,Map<String,Object> model);
    }
```

## MemberFormControllerV4

단순하게 new-form 이라는 `뷰의 논리 이름`만 반환하면 된다.

```java
    public class MemberFormControllerV4 implements ControllerV4 {

        private MemberRepository memberRepository = MemberRepository.getInstance();

        @Override
        public String process(Map<String, String> paramMap, Map<String, Object> model) {
            return "new-form";
        }
    }
```

## MemberSaveControllerV4

```java
    public class MemberSaveControllerV4 implements ControllerV4 {

        private MemberRepository memberRepository = MemberRepository.getInstance();

        @Override
        public String process(Map<String, String> paramMap, Map<String, Object> model) {
            // 파라미터 정보는 map에 담겨있다. map에서 필요한 요청 파라미터를 조회하면 된다.
            String username = paramMap.get("username");
            int age = Integer.parseInt(paramMap.get("age"));

            // 비즈니스 로직 실행
            Member member = new Member(username, age);
            Member save = memberRepository.save(member);
            // 모델에 뷰에서 필요한 member 객체를 담는다.
            model.put("member",member);

            // 논리 이름을 리턴
            return "save-result";
        }
    }
```

## MemberListControllerV4

```java
public class MemberListControllerV4 implements ControllerV4 {

    private MemberRepository memberRepository = MemberRepository.getInstance();

    @Override
    public String process(Map<String, String> paramMap, Map<String, Object> model) {

        List<Member> members = memberRepository.findAll();

        model.put("members",members);
        
        return "members";
    }
}
```

```java
    @WebServlet(name = "frontControllerServletV4", urlPatterns = "/front-controller/v4/*")
    public class FrontControllerServletV4 extends HttpServlet {

        private Map<String, ControllerV4> controllerMap = new HashMap<>();

        public FrontControllerServletV4() {

            controllerMap.put("/front-controller/v4/members/new-form",new MemberFormControllerV4());
            controllerMap.put("/front-controller/v4/members/save",new MemberSaveControllerV4());
            controllerMap.put("/front-controller/v4/members",new MemberListControllerV4());
        }

        @Override
        protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // 로거로 찍는게 좋지만 sout으로 검증해본다.
            // http://localhost:8080/front-controller/v2/* 로 요청 시 잘 호출이 잘 되는지 확인을 해봐야한다.
            System.out.println("FrontControllerServletV4.service");
            // controllerV1Map에 있는 key값이 requestURI에 저장된다.
            String requestURI = request.getRequestURI();
            // controllerV1Map에 인스턴스 주소가 controller애 저장된다. 
            // IS-A관계
            // ex) ControllerV3 controller = new MemberFormControllerV3();
            ControllerV4 controller = controllerMap.get(requestURI);
            // 만약 등록 된 controller가 없다면 즉 null일 경우 404 페이지
            if(controller == null){
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            // paramMap에는 쿼리스트링 즉, 클라이언트가 입력한 input값들이  paramMap에 key,value로 담긴다.
            // ex) paramMap = {age=19, username=jang}
            Map<String, String> paramMap = createParamMap(request);

            Map<String,Object> model = new HashMap<>();
            String viewName = controller.process(paramMap, model);
            MyView view = viewResolver(viewName);

            view.render(model,request,response);
        }
        
        // 논리 이름을 파라미터로 받아서 물리이름으로 객체 생성 후 리턴
        // 왜 이렇게 하는가 ? 경로가 바뀔 경우 모든 컨트롤러에서 경로를 변경해줘야하는 번거로움이 발생한다. 
        // 중복성도 제거해야할 부분이 있기 때문에 아래와 같이 메소드를 만들어서 관리한다.
        private MyView viewResolver(String viewName) {
            return new MyView("/WEB-INF/views/" + viewName + ".jsp");
        }
        // 클라이언트가 입력한 input값을 Map에 담기 위해서 request객체를 파라미터로 받고 getParameterNames() 전체 파라미터를 조회한다.        
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
│       ├─📄MyView.java
│       └─📁v4
│          ├─📄ControllerV4.java
│          └─📄FrontControllerServletV3.java
│          ├─📁controller
│          ├─📄ControllerV3.java
│          ├─📄MemberSaveControllerV3.java
│          ├─📄MemberListControllerV3.java
├── 📁WEB-INF
│   └─📁views
│     ├─📄members.jsp
│     ├─📄new-form.jsp
│     └─📄save-result.jsp
```