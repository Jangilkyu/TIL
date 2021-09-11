# @Entity

```java
    @Entity
    public class Student {
        private Long id;
        private String name;
    }
```

`spring-boot-starter-data-jpa` 의존성을 추가한 후 `@Entity`애노테이션을 클래스 위에 선언하면 자바 클래스와 테이블이 매핑이 되고 JPA가 관리한다.

|id|name|
|:----:|:----|
|100|장일규|
|200|류수정|

## **entity 속성**

```java
    @Entity(name = "Student")
```

Entity에 속성에는 `name`이라는 속성이 있다.

JPA에서 사용할 `엔티티 이름`을 지정한다.

기본값은 클래스 이름 그대로 사용한다.예를들어, Student

동일한 클래스 이름이 없다면 기본값을 사용하는 것을 권장한다.


# **@Table**

@Table은 엔티티와 매핑할 테이블을 지정한다.

데이터베이스에 Stn이라는 테이블과 매핑을 하게 된다.

```java
    @Entity
    @Table(name ="Stn")
    public class Student {
        private Long id;
        private String name;
    }
```

|속성|기능|기본값|
|:----:|:----:|:----:|
|name|매핑할 테이블 이름|엔티티 이름을 사용|
|catalog|데이터베이스 catalog 매핑||
|schema|데이터베이스 schema 매핑||
