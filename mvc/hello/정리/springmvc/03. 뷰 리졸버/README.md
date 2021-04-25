# 뷰 리졸버


## 뷰 리졸버 동작 방식

![image](https://user-images.githubusercontent.com/69107255/115962430-52366880-a556-11eb-85da-413220d4b27e.png)


## OldController - View 조회할 수 있도록 변경

`OldController`에 return을 `new ModelAndView("new-form");`로 View를 사용할 수 있도록 다음 코드를 추가했다.

```java
package hello.servlet.web.springmvc.old;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Component("/springmvc/old-controller")
public class OldController implements Controller {

    @Override
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println("OldController.handleRequest");

        return new ModelAndView("new-form");
    }
}
 ```

`http://localhost:8080/springmvc/old-controller`로 실행하면 웹 브라우저에 `Whitelabel Error Page` 가 나오고, 실행해보면 컨트롤러를 정상 호출되지만 콘솔에 `OldController.handleRequest` 이 출력될 것이다.

## 뷰 리졸버 - InternalResourceViewResolver

스프링 부트는 `InternalResourceViewResolver` 라는 뷰 리졸버를 자동으로 등록하는데,<br>
이때 `application.properties` 에 등록한 `spring.mvc.view.prefix` , `spring.mvc.view.suffix` 설정 정보를 사용해서 등록한다.

application.properties 에 다음 코드를 추가하자
```java
spring.mvc.view.prefix=/WEB-INF/views/ 
spring.mvc.view.suffix=.jsp
```

### 스프링 부트가 자동 등록하는 뷰 리졸버

```java
1순위 BeanNameViewResolver : 빈 이름으로 뷰를 찾아서 반환한다. (예: 엑셀 파일 생성 기능에 사용)
2순위 InternalResourceViewResolver : JSP를 처리할 수 있는 뷰를 반환한다.
```

1. 핸들러 어댑터 호출

- 핸들러 어댑터를 통해 `new-form` 이라는 논리 뷰 이름을 획득한다.

2. ViewResolver 호출

- `new-form` 이라는 뷰 이름으로 viewResolver를 순서대로 호출한다.
- `BeanNameViewResolver` 는 `new-form` 이라는 이름의 스프링 빈으로 등록된 뷰를 찾아야 하는데 없다. 
- `InternalResourceViewResolver` 가 호출된다.

3. InternalResourceViewResolver

- 이 뷰 리졸버는 `InternalResourceView` 를 반환한다.

4. 뷰 - InternalResourceView

- `InternalResourceView` 는 JSP처럼 포워드 `forward()` 를 호출해서 처리할 수 있는 경우에 사용한다. 

5. view.render()

- `view.render()` 가 호출되고 `InternalResourceView` 는 `forward()` 를 사용해서 JSP를 실행한다.