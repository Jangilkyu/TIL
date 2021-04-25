# 프론트 컨트롤러 도입 - v1

## 목표

```
프론트 컨트롤러를 단계적으로 도입해보자.
이번 목표는 기존 코드를 최대한 유지하면서, 프론트 컨트롤러를 도입하는 것이다. 먼저 구조를 맞추어두고 점진적으로 리펙터링 해보자.
```

## V1 구조

![image](https://user-images.githubusercontent.com/69107255/115206411-87495200-a135-11eb-873c-445efd14011b.png)

1. 클라이언트 
    - 클라이언트가 HTTP요청을 한다.
2. Front-Controller
    - Front-Controller라는 Servlet이 요청을 받는다.
3. 매핑 정보
    - 클라이언트가 요청한 HTTP 요청에 url정보를 가지고 매핑 정보에는 Controller정보가 있다. 매핑 정보를 조회 후 어떤 Controller가 호출되어야 하는지 찾은 후 Controller를 호출한다.

4. Controller
    - 컨트롤러에서 JSP forward를 한다.

5. JSP
- 클라이언트에게 요청했던 HTML응 응답한다.

## ControllerV1.java
```java
 public interface ControllerV1 {
      void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
  }
```

## MemberFormControllerV1 - 회원 등록 컨트롤러
```java
  public class MemberFormControllerV1 implements ControllerV1 {
        @Override
        public void process(HttpServletRequest request, HttpServletResponseresponse) throws ServletException, IOException {
        String viewPath = "/WEB-INF/views/new-form.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath); dispatcher.forward(request, response);
        } 
}

```

## MemberSaveControllerV1 - 회원 저장 컨트롤러
```java
public class MemberSaveControllerV1 implements ControllerV1 {

    private MemberRepository memberRepository = MemberRepository.getInstance();

    @Override
    public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        int age = Integer.parseInt(request.getParameter("age"));

        Member member = new Member(username, age);
        memberRepository.save(member);

        // Model에 데이터를 보관한다.
        request.setAttribute("member",member);
        // 뷰페이지 경로를 지정한다.
        String viewPath = "/WEB-INF/views/save-result.jsp";

        RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath);
        dispatcher.forward(request,response);

    }
```

## MemberListControllerV1 - 회원 목록 컨트롤러
```java
public class MemberListControllerV1 implements ControllerV1 {

    private MemberRepository memberRepository = MemberRepository.getInstance();

    @Override
    public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 로직 실행
        List<Member> members = memberRepository.findAll();
        // 뷰페이지로 전달할때 상태 유지
        request.setAttribute("members",members);
        // 뷰페이지 경로 설정 
        String viewPath = "/WEB-INF/views/members.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath);
        dispatcher.forward(request,response);
    }
}
```

## FrontControllerServletV1 - 프론트 컨트롤러
```java
    @WebServlet(name = "frontControllerServletV1", urlPatterns = "/front-controller/v1/*")
    public class FrontControllerServletV1  extends HttpServlet {
        // 매핑 정보
        private Map<String,ControllerV1> controllerV1Map = new HashMap<>();
        
        // 생성자에 생성 될 때 실행 될 수 있도록 매핑 정보를 담아 놓는다.
        public FrontControllerServletV1() {
            controllerV1Map.put("/front-controller/v1/members/new-form",new MemberFormControllerV1());
            controllerV1Map.put("/front-controller/v1/members/save",new MemberSaveControllerV1());
            controllerV1Map.put("/front-controller/v1/members",new MemberListControllerV1());
        }

        @Override
        protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // 로거로 찍는게 좋지만 sout으로 검증해본다.
            // http://localhost:8080/front-controller/v1/* 로 요청 시 잘 호출이 잘 되는지 확인을 해봐야한다.
            System.out.println("FrontControllerServletV1.service");

            // controllerV1Map에 있는 key값이 requestURI에 저장된다.
            String requestURI = request.getRequestURI();

            // controllerV1Map에 인스턴스 주소가 controller애 저장된다. 
            // IS-A관계
            ControllerV1 controller = controllerV1Map.get(requestURI);
            
            // 만약 등록 된 controller가 없다면 즉 null일 경우 404 페이지
            if(controller == null){
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // 만약 등록된 controller가 있다면 override한 메소드 실행
            controller.process(request,response);

        }
    }
```
## 프론트 컨트롤러 분석

- urlPatterns
    - urlPatterns = `"/front-controller/v1/*"` : `/front-controller/v1` 를 포함한 하위 모든 요청은 이 서블릿에서 받아들인다.
    - 예) `/front-controller/v1` , `/front-controller/v1/a` , `/front-controller/v1/a/b`

- controllerMap
    - key: 매핑 URL
    - value: 호출될 컨트롤러

- service()
    - 먼저 requestURI 를 조회해서 실제 호출할 컨트롤러를 controllerMap 에서 찾는다. 만약 없다면 404(SC_NOT_FOUND) 상태 코드를 반환한다.
    - 컨트롤러를 찾고 controller.process(request, response); 을 호출해서 해당 컨트롤러를 실행한다.

- JSP
    - JSP는 이전 MVC에서 사용했던 것을 그대로 사용한다.


## 디렉토리 구조
```
📁servlet
├📁src/main/java
├── 📁hello
│   ├─📁servlet
│   └─📁frontcontroller
│      └─📁v1
│         └─📁controller
│           ├─📄MemberFormControllerV1
│           ├─📄MemberSaveControllerV1
│           ├─📄MemberListControllerV1
│           └─📄ControllerV1
│           └─📄FrontControllerServletV1
├── 📁WEB-INF
│   └─📁views
      └─📄ControllerV1
```
