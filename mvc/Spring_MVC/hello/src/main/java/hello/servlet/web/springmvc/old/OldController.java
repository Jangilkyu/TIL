package hello.servlet.web.springmvc.old;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * url이 호출되면 Http요청이 들어간다.
 * Handler-Mapping에서 Controller를 찾아와야 한다.
 * Handler-Adapter를 통해 해당 콘트롤러를 실행할 수 있는지 검증해야한다.
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
