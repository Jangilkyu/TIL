
# **@RequestParam**

클라이언트가 요청할 시 전달하는 값을 Controller의 매개변수로 1:1 맵핑할때 사용되는 어노테이션이다.

## Controller

```java
@Slf4j
@Controller
public class RequestParamController {

    @ResponseBody
    @GetMapping("/request-param")
    public String requestParam(
        @RequestParam("username")  String memberName,
        @RequestParam("age") int memberAge
    ){
        System.out.println("RequestParamController.requestParam");
        log.info("username={}, age={}",memberName, memberAge);

        return "ok";
    }

}
```

클라이언트가 /?username=jangilkyu로 요청 시, 핸들러 매개변수 인 memberName에 'jangilkyu'가 매핑된다. 

![image](https://user-images.githubusercontent.com/69107255/128535733-7dab50a9-45e9-42ec-a0ca-4becc86e1b94.png)


## **@RequestParam 특징**

- `@RequestParam`으로 파라미터 이름으로 바인딩 할 수 있다.
- @RequestParam( value ) -> value의 속성이 파라미터 이름으로 사용된다.
    - 예시) `@RequestParam("username") String memberName` -> `reqeust.getParameter("username")`으로 쓰는것과 같다.
- `@RequestParam`의 파라미터 이름과 변수명이 같으면 `@RequestParam String username`으로 (value)를 생략할 수 있다.
- String, int, Integer 등 단순 타입 시 파라미터 이름과 변수명이 일치하면 `@RequestParam`도 생략할 수 있다. 

## **@RequestParam 기본 속성**

```java
public String ParamDef(
@RequestParam(value="memberName", defaultValue="defaultUser", required= false) String memberName) ) {
    
}
```

- value는 key대한 값을 바인딩한다.
- required는 기본이 true이고,값이 반드시 있어야 한다. 없을 시 400에러가 발생한다.
- defaultValue는 파라미터에 매핑될 값이 없을 경우 기본 값으로 세팅해준다.


@RequestParam과 @PathVariable은 모두 요청 URI에서 사용할 수 있지만 차이가 있다.

@RequestParam은 쿼리문자열에서 값을 추출하고, @PathVariable은 URI경로에서 값을 추출한다.
