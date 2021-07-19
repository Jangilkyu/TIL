# Form Login 인증

![image](https://user-images.githubusercontent.com/69107255/126162648-24a84754-19b5-4c03-a385-ed0315ddc3b6.png)

**Form 로그인 인증 기능이 작동한다.**

```java
    http.formLogin() 
```

```java
    @Slf4j
    @Configuration
    @EnableWebSecurity
    public class SecurityConfig extends WebSecurityConfigurerAdapter {

        @Override
        protected void configure(HttpSecurity http) throws Exception {
            // 인가 정책
            http
                    .authorizeRequests() // 요청에 대한 보안 검사가 시작된다.
                    .anyRequest().authenticated(); // 현재 어떠한 요청에도 인증을 받아야 한다.

            // 인증 정책
            http
                    .formLogin() // form Login 방식으로 인증을 받을 수 있다.
                   .loginPage("/loginPage") // 사용자 정의 로그인 페이지
                    .defaultSuccessUrl("/") // 로그인이 성공 후 이동할 페이지
                    .failureUrl("/login") // 로그인이 실패 후 이동할 페이지
                    .usernameParameter("userId") // 아이디 파라미터 이름 설정
                    .passwordParameter("passwd") // 패스워드 파라미터 이름 설정 
                    .loginProcessingUrl("/login_proc") // 로그인 Form태그 Action Url을 설정 
                    .successHandler(new AuthenticationSuccessHandler() { // 로그인을 성공한 후 핸들러 
                        @Override
                        public void onAuthenticationSuccess(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Authentication authentication) throws IOException, ServletException {
                            log.info("authentication = {}", authentication.getName());
                        }
                    })
                    .failureHandler(new AuthenticationFailureHandler() { // 로그인이 실패된 후 핸들러
                        @Override
                        public void onAuthenticationFailure(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AuthenticationException exception) throws IOException, ServletException {
                            log.info("exception " + exception.getMessage());
                        }
                    })
                    .permitAll();
        }
    }
```

## **loginPage("/loginPage")**

spring-security 의존성을 추가한 후 페이지 request시에 구현하지 않았던 Login form이 아닌 사용자가 직접 loginPage를 지정해 줄 수 있다.


## **defaultSuccessUrl("/")**

로그인이 성공하면 이동 할 페이지 이다. 


## **failureUrl("/login")**

로그인이 실패되면 이동 할 페이지이다.

## **usernameParameter("userId")passwordParameter("passwd")**

서버로 전달 될 파라미터이름을 설정 할 수 있다.

![image](https://user-images.githubusercontent.com/69107255/126169010-a9a6a968-d631-4a10-b8cb-06ed570dd076.png)


## **.loginProcessingUrl("/login_proc")**

![image](https://user-images.githubusercontent.com/69107255/126169625-255a56bb-81ef-4a14-a29f-30badd1a5e4f.png)


## **successHandler(new AuthenticationSuccessHandler() {}**

로그인이 성공했을 시 이동하는 핸들러이다.

사용자에 아이디를 로그로 출력해보았다.

![image](https://user-images.githubusercontent.com/69107255/126170173-c45c92f1-20f5-41f8-9855-d5ebd3eb3fa9.png)


## **failureHandler(new AuthenticationFailureHandler()**

로그인이 실패했을 때 이동하는 핸들러이다.

예외 문구를 로그로 출력해 보았다.

![image](https://user-images.githubusercontent.com/69107255/126170589-7c84d58c-1a5e-4ca3-acd2-1528632ec501.png)
