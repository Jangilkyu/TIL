# @ModelAttribute를 사용하는 방법

```java
    @Getter @Setter
    public class MemberDto {

        private String username;
        private int age;

    }
```

**@ModelAttribute** 테스트를 위해서 요청 파라미터를 바인딩 받을 객체인 **MemberDto** 라는 클래스를 만들었다. 

Lombok을 사용해 @Getter와 @Setter를 추가하였다. `@ModelAttribute`를 사용하려면 getter와 setter가 정의되어 있어야한다.


```java
    @Slf4j
    @RestController
    public class MemberController {

        @GetMapping("/user")
        public ResponseEntity<String> modelAttribute(@ModelAttribute MemberDto memberDto){
            log.info("username = {}, age={}",memberDto.getUsername(), memberDto.getAge());
            return ResponseEntity.ok().body("ok");
        }
    }
```

스프링MVC는 `@ModelAttribute`가 있을 시 아래와 같이 실행이 된다.

## 1. 파라미터로 넘겨 준 타입의 오브젝트를 자동으로 생성한다.

클래스에는 Getter와 Setter가 만들어져 있어야한다.

MemberDto 타입에 참조 변수인 memberDto를 자동으로 생성한 후, 요청 파라미터의 이름으로 MemberDto객체의 **프로퍼티**를 찾는다. 그 후 해당 프로퍼티의 **setter**를 호출한 후 파라미터의 값을 입력(바인딩)한다.

ex) 파라이미터 이름이 age일 시 setAge()메소드를 찾은 후 호출하면서 값을 입력한다.

```
    http://localhost:8080/user?username=jang&age=29
```

위와 같이 들어오는 값들이 MemberDto클래스의 userName, age 각 프로퍼티에  setter를 통해서 해당 멤버 변수에 입력(바인딩)된다.