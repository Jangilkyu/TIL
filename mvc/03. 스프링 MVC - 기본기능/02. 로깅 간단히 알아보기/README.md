# 로깅 간단히 알아보기

- 운영 시스템에서는 `System.out.println()` 같은 시스템 콘솔을 사용해서 필요한 정보를 출력하지 않고, 별도의 로깅 라이브러리를 사용해서 로그를 출력한다.
참고로 로그 관련 라이브러리도 많고, 깊게 들어가면 끝이 없기 때문에, 여기서는 최소한의 사용 방법만 알아본다.

- 로깅 라이브러리
스프링 부트 라이브러리를 사용하면 스프링 부트 로깅 `라이브러리( spring-boot-starter-logging )`가 함께 포함된다.
스프링 부트 로깅 라이브러리는 기본으로 다음 로깅 라이브러리를 사용한다.

##  로그 사용시 장점
- 쓰레드 정보, 클래스 이름 같은 부가 정보를 함께 볼 수 있고, 출력 모양을 조정할 수 있다.
- 로그 레벨에 따라 개발 서버에서는 모든 로그를 출력하고, 운영서버에서는 출력하지 않는 등 로그를 상황에 맞게 조절할 수 있다.
- 시스템 아웃 콘솔에만 출력하는 것이 아니라, 파일이나 네트워크 등, 로그를 별도의 위치에 남길 수 있다. 특히 파일로 남길 때는 일별, 특정 용량에 따라 로그를 분할하는 것도 가능하다.
- 성능도 일반 System.out보다 좋다. (내부 버퍼링, 멀티 쓰레드 등등) 그래서 실무에서는 꼭 로그를 사용해야 한다.

```java
    @RestController // @Controller는 view-resolver에서 찾고 리턴되는게 view에 이름이지만 @RestController는 문자열 이름이 리턴된다.
    public class LogTestController {

        // org.slf4j를 사용해야한다.
        // getClass()를 통해 내 클래스인 LogTestController를 지정해준다.
        private final Logger log = LoggerFactory.getLogger(getClass());

        @GetMapping("/log-test")
        public String logTest() {
            String name = "spring";

            // sout을 통해서 찍으면 console창에 찍힌다.
            System.out.println("name = " + name);

            /*
                Log LEVEL: TRACE > DEBUG > INFO > WARN > ERROR
            */

            log.trace("trace log={}", name);
            // 개발 서버에서 보는 것
            log.debug("debug log={}", name);
            // 비즈니스 서버
            // 로그로 찍을 시 시간 / 정보 / 프로세스 아이디 / 실행 한 쓰레드 / 컨트롤러 이름 / 메시지 출력가 출력된다.
            // 2021-04-25 20:21:53.471  INFO 18660 --- [nio-8080-exec-2] hello.springmvc.basic.LogTestController  :  info log = spring
            log.info(" info log = {}", name);
            // 경고
            log.warn(" warn log={}", name);
            // 에러 로그
            log.error("error log={}", name);


            //로그를 사용하지 않아도 a+b 계산 로직이 먼저 실행됨, 이런 방식으로 사용하면 안된다.!!
            // +연산이 사용 되면서 메모리도 사용되고 cpu도 사용이 된다.
            log.debug("String concat log=" + name);

            // 현재 로그보다 상위레벨 로그를 출력하려고 할 경우 출력이 되지 않는 것은 당연하고 메서드 호출 후 파라미터로 넘기기 때문에 위에 코 아무 연산이 일어나지 않는다. 
            log.debug("String concat log=" + name);
            

            return "ok";
        }
    }
```
## 로그 레벨 설정

📄application.properties

```java
#전체 로그 레벨 설정(기본 info) 
logging.level.root=info

#hello.springmvc 패키지와 그 하위 로그 레벨 설정 
logging.level.hello.springmvc=debug
```


### 테스트
- 로그가 출력되는 포멧 확인
    - 시간, 로그 레벨, 프로세스 ID, 쓰레드 명, 클래스명, 로그 메시지
- 로그 레벨 설정을 변경해서 출력 결과를 보자.
    - LEVEL: `TRACE > DEBUG > INFO > WARN > ERROR`
    - 개발 서버는 debug 출력
    - 운영 서버는 info 출력
- `private final Logger log = LoggerFactory.getLogger(getClass());`
    - `@Slf4j` 로 변경이 가능하다.

### 실행 화면

logging.level.root 레벨이 `info`이기 때문에 `trace`와 `debug`는 출력이 되지 않는다.

![image](https://user-images.githubusercontent.com/69107255/115991679-98e29c00-a604-11eb-9b28-ceac26ecb742.png)


### 순서도

1. 실행
아래에 url로 실행한다.

- http://localhost:8080/log-test

2. 매핑 정보

- @RestController
    - `@Controller` 는 반환 값이 `String` 이면 뷰 이름으로 인식된다. 그래서 `뷰를 찾고 뷰가 랜더링` 된다.
    - `@RestController` 는 반환 값으로 뷰를 찾는 것이 아니라, `HTTP 메시지 바디에 바로 입력`한다. 따라서 실행 결과로 ok 메세지를 받을 수 있다. `@ResponseBody` 와 관련이 있다.

## 올바른 로그 사용법

- log.debug("data="+data)
    - 로그 출력 레벨을 info로 설정해도 해당 코드에 있는 "data="+data가 실제 실행이 되어 버린다. 결과적으로 문자 더하기 연산이 발생한다.
- log.debug("data={}", data)
    - 로그 출력 레벨을 info로 설정하면 아무일도 발생하지 않는다. 따라서 앞과 같은 의미없는 연산이 발생하지 않는다.
<<<<<<< HEAD

## 로그 레벨 설정

application.properties

```java
#전체 로그 레벨 설정(기본 info) 
logging.level.root=info

#hello.springmvc 패키지와 그 하위 로그 레벨 설정 
logging.level.hello.springmvc=debug
```


### 테스트
- 로그가 출력되는 포멧 확인
    - 시간, 로그 레벨, 프로세스 ID, 쓰레드 명, 클래스명, 로그 메시지
- 로그 레벨 설정을 변경해서 출력 결과를 보자.
    - LEVEL: `TRACE > DEBUG > INFO > WARN > ERROR`
    - 개발 서버는 debug 출력
    - 운영 서버는 info 출력
- `private final Logger log = LoggerFactory.getLogger(getClass());`
    - `@Slf4j` 로 변경이 가능하다.
=======
>>>>>>> 61ab8b161d288083ee1c846cc7b0f8280eb40255
