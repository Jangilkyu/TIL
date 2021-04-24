# 스프링 MVC - 시작하기

스프링이 제공하는 컨트롤러는 `애노테이션 기반`으로 동작해서, 
매우 유연하고 실용적이다. 과거에는 자바 언어에 애노테이션이 없기도 했고, 스프링도 처음부터 이런 유연한 컨트롤러를 제공한 것은 아니다.

2강에서 살펴보았듯이  가장 우선순위가 높은 핸들러 매핑은 `RequestMappingHandlerMapping` , 핸들러 어댑터는 `RequestMappingHandlerAdapter` 이다.

## @RequestMapping

스프링은 애노테이션을 활용한 매우 유연하고, 실용적인 컨트롤러를 만들었는데 이것이 바로 `@RequestMapping` 애노테이션을 사용하는 컨트롤러이다. 다들 한번쯤 사용해보았을 것이다.
여담이지만 과거에는 스프링 프레임워크가 MVC 부분이 약해서 스프링을 사용하더라도 MVC 웹 기술은 스트럿츠 같은 다른 프레임워크를 사용했었다. 그런데 `@RequestMapping` 기반의 애노테이션 컨트롤러가 등장하면서, 
MVC 부분도 스프링의 완승으로 끝이 났다.

`@RequestMapping` 의 앞글자를 따서 만든 이름인데, 이것이 바로 지금 스프링에서 주로 사용하는 애노테이션 기반의 컨트롤러를 지원하는 핸들러 매핑과 어댑터이다. **실무에서는 99.9% 이 방식의 컨트롤러를 사용**한다.

## SpringMemberFormControllerV1 - 회원 등록 폼

```java
    package hello.servlet.web.springmvc.v1;

    import org.springframework.stereotype.Controller;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.servlet.ModelAndView;

    /*
        class 레벨에
        @Component //컴포넌트 스캔을 통해 스프링 빈으로 등록
        @RequestMapping
        두개가 있으면 처리할 수 있는 핸들로 대상으로 판단하기 때문에 @Controller대신 위에 두개에 애노테이션만 적어도 실행은 된다.
    */

    // @Controller만 있어도 @Component에 대상이 된다. 따라서 Spring Bean에 자동으로 SpringMemberFormControllerV1가 등록이 된다.
    @Controller
    public class SpringMemberFormControllerV1 {
        @RequestMapping("/springmvc/v1/members/new-form")
        public ModelAndView process() {
            return new ModelAndView("new-form");
        }
    }
```

- @Controller
    - 스프링이 자동으로 스프링 빈으로 등록한다. (내부에 @Component 애노테이션이 있어서 컴포넌트 스캔의 대상이 됨)
    - 스프링 MVC에서 `애노테이션 기반 컨트롤러`로 인식한다.
    - `RequestMappingHandlerMapping` 은 스프링 빈 중에서 `@RequestMapping` 또는 `@Controller` 가 클래스 레벨에 붙어 있는 경우에 **매핑 정보**로 인식한다.

- @RequestMapping
    - **요청 정보**를 매핑한다. 해당 URL이 호출되면 이 메서드가 호출된다. 애노테이션을 기반으로 동작하기 때문에, 메서드의 이름은 임의로 지으면 된다.

 - ModelAndView
    - **모델**과 **뷰** 정보를 담아서 반환하면 된다.


## SpringMemberSaveControllerV1

```java
    @Controller
    public class SpringMemberSaveControllerV1 {

        private MemberRepository memberRepository = MemberRepository.getInstance();

        @RequestMapping("/springmvc/v1/members/save")
        public ModelAndView process(HttpServletRequest request, HttpServletResponse response) {
            String username = request.getParameter("username");
            int age = Integer.parseInt(request.getParameter("age"));
            Member member = new Member(username, age);

            System.out.println("member = " + member);
            memberRepository.save(member);
            ModelAndView mv = new ModelAndView("save-result");
            mv.addObject("member", member);
            return mv;

        }
    }
```

`mv.addObject("member", member)`
- 스프링이 제공하는 `ModelAndView` 를 통해 Model 데이터를 추가할 때는 `addObject()` 를 사용하면 된다. 이 데이터는 이후 `뷰를 렌더링 할 때 사용`된다.


## SpringMemberListControllerV1 - 회원 목록
```java
    package hello.servlet.web.springmvc.v1;

    import hello.servlet.domain.member.Member;
    import hello.servlet.domain.member.MemberRepository;
    import org.springframework.stereotype.Controller;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.servlet.ModelAndView;

    import java.util.List;

    @Controller
    public class SpringMemberListControllerV1 {
        private MemberRepository memberRepository = MemberRepository.getInstance();

        @RequestMapping("/springmvc/v1/members")
        public ModelAndView process() {
            List<Member> members = memberRepository.findAll();
            ModelAndView mv = new ModelAndView("members");
            mv.addObject("members", members);
            return mv;
        }
    }
```