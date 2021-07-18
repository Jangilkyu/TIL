## 타임리프 특징

- 서버 사이드 HTML 렌더링 (SSR) 네츄럴 템플릿
- 스프링 통합 지원

## 서버 사이드 HTML 렌더링 (SSR)
- 타임리프는 백엔드 서버에서 HTML을 동적으로 렌더링 하는 용도로 사용된다.

## 타임리프 사용 선언

```html
<html xmlns:th="http://www.thymeleaf.org">
```


# **텍스트 - text, utext**

텍스트를 출력하는 기능을 알아보자

타임리프는 기본적으로 HTML 테그의 속성에 기능을 정의해서 동작한다. HTML의 콘텐츠(content)에 데이터를 출력할 때는 다음과 같이 `th:text` 를 사용하면 된다.

```html
    <span th:text="${data}">
```

HTML 태그 속성이 아닌 HTML 콘텐츠 영역안에 직접 데이터를 출력하고 싶을 경우에는 `[[...]]`를 사용하면 된다.


```html
    컨텐츠 안에서 직접 출력하는 법 = [[${data}]]
```


# **변수 - SpringEL**

Controller내부에 inner User class를 만들고 멈버변수로 `username`과 `age`가 있다.

```java
    @Data
    static class User {
        private String username;
        private int age;

        public User(String username, int age) {
            this.username = username;
            this.age = age;
        }
    }
```

```java
    @GetMapping("/variable")
    public String variable(Model model){
        // == 객체 두개 생성 ==
        User userA = new User("userA", 10);
        User userB = new User("userA", 10);

        // == 리스트에 객체 두개 추가 ==
        ArrayList<User> list = new ArrayList<>();
        list.add(userA);
        list.add(userB);

        // == Map에 객체 두개 추가 ==
        Map<String,User> map = new HashMap<>();
        map.put("userA",userA);
        map.put("userB",userB);

        // == 상태 유지 ==
        model.addAttribute("user",userA);
        model.addAttribute("users",list);
        model.addAttribute("userMap",map);

        return "basic/variable";
    }
```

### Object

`user.username` : user의 username을 프로퍼티 접근 👉 `user.getUsername()`
`user['username']` : 위와 같음 `user.getUsername()`
`user.getUsername()` : user의 `getUsername()` 을 직접 호출


```html
<ul>Object
    <li>${user.username} = <span th:text="${user.username}"></span></li>
    <li>${user['username']} = <span th:text="${user['username']}"></span></li>
    <li>${user.getUsername()} = <span th:text="${user.getUsername()}"></span></li>
</ul>
```

![image](https://user-images.githubusercontent.com/69107255/126034295-774856e0-bab5-4a43-ba60-204729873067.png)

### List


`users[0].username` : List에서 첫 번째 회원을 찾고 username 프로퍼티 접근 👉 `list.get(0).getUsername()`
`users[0]['username']` : 위와 같음
`users[0].getUsername()` : List에서 첫 번째 회원을 찾고 메서드 직접 호출

```html
<ul>List
    <li>${users[0].username} = <span th:text="${users[0].username}"></span></li>
    <li>${users[0]['username']} = <span th:text="${users[0]['username']}"></span></li>
    <li>${users[0].getUsername()} = <span th:text="${users[0].getUsername()}"></span></li>
</ul>
```

### Map

`userMap['userA'].username` : Map에서 userA를 찾고, username 프로퍼티 접근 👉`map.get("userA").getUsername()`
`userMap['userA']['username']`: 위와 같음
`userMap['userA'].getUsername()` : Map에서 userA를 찾고 메서드 직접 호출

```
<ul>Map
    <li>${userMap['userA'].username} = <span th:text="${userMap['userA'].username}"></span></li>
    <li>${userMap['userA']['username']} = <span th:text="${userMap['userA']['username']}"></span></li>
    <li>${userMap['userA'].getUsername()} = <span th:text="${userMap['userA'].getUsername()}"></span></li>
</ul>
```

### **지역 변수 선언**

선언한 태그 안에서만 사용이 가능하다. scope을 벗어나면 사용 불가!

`th:with` 를 사용하면 지역 변수를 선언해서 사용할 수 있다. 지역 변수는 선언한 테그 안에서만 사용할 수 있다.

first 변수에 users[0]객체에 정보를 담았다.

first.username으로 접근하여 사용할 수 있다.

```java
    <h1>지역 변수 - (th:with)</h1>
    <div th:with="first=${users[0]}">
        <p>처음 사람의 이름은 <span th:text="${first.username}"></span></p>
    </div>
```

# 리터럴

타임리프에서 문자 리터럴은 항상 `'(작은 따옴표)`로 감싸야한다.

```html
    <span th:text="'hello'">
```

하지만 문자를 `'(작은 따옴표)`로 감싸는 작업은 귀찮다. 타임리프에서는 공백 없이 쭉 이어 질 경우 하나의 의미있는 토큰으로 인지하고 다음과 같이 작은 따옴표를 생략할 ㅅ ㅜ 있다.

룰: `A-Z`,`a-z`,`0-9`,`[]`,`.`,`-`,`_`

```html
    <span th:text="hello">
    <li>'hello' + ' world!' = <span th:text="'hello' + ' world!'"></span></li>
    <li>'hello world!' = <span th:text="'hello world!'"></span></li>
    <li>'hello ' + ${data} = <span th:text="'hello ' + ${data}"></span></li>
    <li>리터럴 대체 |hello ${data}| = <span th:text="|hello ${data}|"></span></li>

    <!-- 에러!! 
        문자 리터럴은 원칙상 ' 로 감싸야 한다. 중간에 공백이 있어서 하나의 의미있는 토큰으로도 인식되지 않는다.
        따라서, <span th:text="'hello world!'"></span> -> '(작은 따옴표)로 감싸야 동작한다.
    -->
    <span th:text="hello world!"></span>
```

# 속성 값 설정

- **속성 설정**
    - `th:*` 속성을 지정하면 타임리프는 기존 속성을 `th:*` 로 지정한 속성으로 대체한다. 기존 속성이 없다면 새로 만든다
    - **<input type="text" name="mock" th:name="userA" />** -> 타임리프 렌더링 후 `<input type="text" name="userA" />`

- **속성 추가**
    - th:attrappend  : 속성 값의 값에 값을 추가한다.
    - th:attrprepend : 속성 값의 뒤에 값을 추가한다.
    - th:classappend : class 속성에 자연스럽게 추가한다.

- **checked 처리**
    - HTML에서는 `<input type="checkbox" name="active" checked="false" />` 이 경우에도 checked 속성이 있기 때문에 checked 처리가 되어버린다.
    - 타임리프의 th:checked 는 값이 false 인 경우 checked 속성 자체를 제거한다. `<input type="checkbox" name="active" th:checked="false" />` 
      👉 타임리프 렌더링 후: `<input type="checkbox" name="active" />`

```html
    <h1>속성 설정</h1>
        <!-- input태그에 name이 userA로 렌더링된다.  -->
        <input type="text" name="mock" th:name="userA" />
    <h1>속성 추가</h1>
        <!-- class에 text 뒤에 large가 붙어서 class이름이 textlarge가 된다. -->
        - th:attrappend = <input type="text" class="text" th:attrappend="class=' large'" /><br/>
        <!-- class에 test 앞에 large가 붙어서 largetext가 된다. -->
        - th:attrprepend = <input type="text" class="text" th:attrprepend="class='large '" /><br/>
        <!-- 띄어쓰기를 안해도 적절하게 text large로 class이름을 렌더링 해준다. -->
        - th:classappend = <input type="text" class="text" th:classappend="large"><br/>
    <h1>checked 처리</h1>
        - checked o <input type="checkbox" name="active" th:checked="true" /><br/>
        - checked x <input type="checkbox" name="active" th:checked="false" /><br/>
        - checked=false <input type="checkbox" name="active" checked="false" /><br/>
```