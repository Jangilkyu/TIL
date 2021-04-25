package hello.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name ="helloServlet", urlPatterns = "/hello")
public class HelloServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

       // HelloServlet.service
        System.out.println("HelloServlet.service");
        // request = org.apache.catalina.connector.RequestFacade@64f70d8c
        System.out.println("request = " + request);
        // response = org.apache.catalina.connector.ResponseFacade@ad3b6d
        System.out.println("response = " + response);

        String username = request.getParameter("username");
        // http://localhost:8080/hello?username=jang
        // username = jang
        System.out.println("username = " + username);

        response.setContentType("text/plain");
        response.setCharacterEncoding("utf-8");
        response.getWriter().write("hello" + username);
    }
}
