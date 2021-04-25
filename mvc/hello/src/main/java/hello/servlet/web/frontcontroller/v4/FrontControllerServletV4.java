package hello.servlet.web.frontcontroller.v4;

import hello.servlet.web.frontcontroller.MyView;
import hello.servlet.web.frontcontroller.v4.controller.MemberFormControllerV4;
import hello.servlet.web.frontcontroller.v4.controller.MemberListControllerV4;
import hello.servlet.web.frontcontroller.v4.controller.MemberSaveControllerV4;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "frontControllerServletV4", urlPatterns = "/front-controller/v4/*")
public class FrontControllerServletV4 extends HttpServlet {
    // 매핑 정보
    private Map<String, ControllerV4> controllerMap = new HashMap<>();
    // 생성자에 생성 될 때 실행 될 수 있도록 매핑 정보를 담아 놓는다.
    public FrontControllerServletV4() {
        controllerMap.put("/front-controller/v4/members/new-form",new MemberFormControllerV4());
        controllerMap.put("/front-controller/v4/members/save",new MemberSaveControllerV4());
        controllerMap.put("/front-controller/v4/members",new MemberListControllerV4());
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 로거로 찍는게 좋지만 sout으로 검증해본다.
        // http://localhost:8080/front-controller/v4/* 로 요청 시 잘 호출이 잘 되는지 확인을 해봐야한다.
        System.out.println("FrontControllerServletV4.service");
        // 클라이언트가 요청한 uri주소를 담는다.
        String requestURI = request.getRequestURI();
        System.out.println("requestURI = " + requestURI);

        // controllerMap.get(requestURI);는 클라이언트가 요청한 주소와 controllerMap에 key값과 비교하여 IS-A관계로 controller참조 변수에 주소를 담는다.
        ControllerV4 controller = controllerMap.get(requestURI);
        System.out.println("controller = " + controller);

        // 만약 controller 즉, 비정상적인 경로라면 404를 응답한다.
        if(controller == null){
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // paramMap에는 쿼리스트링 즉, 클라이언트가 입력한 input값들이 paramMap에 key,value로 담긴다.
        // ex) paramMap = {age=19, username=jang}
        Map<String, String> paramMap = createParamMap(request);

        Map<String,Object> model = new HashMap<>();
        String viewName = controller.process(paramMap, model);
        MyView view = viewResolver(viewName);

        view.render(model,request,response);
    }

    private MyView viewResolver(String viewName) {
        return new MyView("/WEB-INF/views/" + viewName + ".jsp");
    }

    private Map<String, String> createParamMap(HttpServletRequest request) {
        Map<String,String> paramMap = new HashMap<>();
        request.getParameterNames().asIterator()
                .forEachRemaining(paramName -> paramMap.put(paramName, request.getParameter(paramName)));
                return paramMap;
    }
}
