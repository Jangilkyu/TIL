
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

![image](https://user-images.githubusercontent.com/69107255/128355501-67472196-2fb1-4b38-a076-851f13831c9d.png)


## **@RequestParam 기본 속성**

```java
@RequestParam(value="memberName", defaultValue="defaultUser", required= false) String memberName)
```

- value는 key대한 값을 바인딩한다.
- required는 기본이 true이고,값이 반드시 있어야 한다. 없을 시 400에러가 발생한다.
- defaultValue는 파라미터에 매핑될 값이 없을 경우 기본 값으로 세팅해준다.