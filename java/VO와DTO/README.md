
## **DTO와 VO의 혼용 원인**

![image](https://user-images.githubusercontent.com/69107255/122050058-11ecbb80-ce1e-11eb-8b0f-94314a1baee5.png)

- `[1판]`에서는 `데이터 전달용 객체를 VO로 정의`
- `[2판]`에서는 `데이터 전달용 객체를 TO로 정의`

데이터 전달용 객체를 VO에서 TO로 바꾸면서 많은 개발자들이 혼용하게 되었을 것이라고 추측한다. 혼동의 여지가 있다.<br>
DTO와 VO는 이름부터 다르기 때문에 구분하여서 사용하여야 한다. 


## **DTO란?**

`Data Transfer Object`이다. 번역하면 **데이터를 전달하기 위해 사용하는 객체**이다. **데이터를 담아서 전달하는 바구니**이다.<br>

**계층 간** 데이터를 전달하기 위한 객체이다.

![image](https://user-images.githubusercontent.com/69107255/122051317-6c3a4c00-ce1f-11eb-9613-dbc5361feeb4.png)

## **DTO의 특징**

- 오직 getter/seteer 메서드 만을 가진다.
- 다른 로직을 가지지 않는다.

## **DTO 사용 예시 클래스**

- DTO의 특징에서 처럼 getter/setter외에 다른 로직은 가지고 있지 않는다.

![image](https://user-images.githubusercontent.com/69107255/122051902-131ee800-ce20-11eb-9b03-638cbc4b4118.png)


## **DTO 사용 예시를 위한 Service Layer 측 메소드**

- 새로운 회원에 이름과 나이를 제 이름과 나이로 설정하였습니다.
- 해당 데이터를 보내는 Service Layer측에서 UserDto객체를 생성하고 `setter`를 통해 전달하고자 하는 데이터를 담아 데이터를 반환해준다.

![image](https://user-images.githubusercontent.com/69107255/122052355-8cb6d600-ce20-11eb-8c1b-5a3ef1a4e460.png)

## **DTO 사용 예시를 위한 Web Layer 측 메소드**

- Data를 받는 쪽인 Web Layer측에서 UserDto 객체를 반환받아서 `getter`를 통해 전달받은 데이터를 꺼내서 사용하면 된다.

![image](https://user-images.githubusercontent.com/69107255/122052856-1b2b5780-ce21-11eb-808c-10edc4479145.png)


## **DTO를 불변객체로 변경**

- DTO는 `setter`메소드를 가질 수 있지만 `setter`메소드를 가질 경우 **데이터가 가변적일 수 있다.**
- `setter`메소드로 값을 새로 설정할 수 있기 때문이다.
- 오른쪽과 같이 `setter`메소드를 삭제하고 `생성자`를 통해 속성값들을 초기화하게 만들어 불변 객체로 만들면 DTO가 전달하는 데이터가 전달되는 과정 중 변경되는 것을 방지할 수 있다. (불변성 보장)

![image](https://user-images.githubusercontent.com/69107255/122054081-524e3880-ce22-11eb-9840-1792d252ebe6.png)


## VO란?

- `Value Object`의 약자이다. **값 그 자체를 표현하는 객체**이다.

예시로 `돈(Money)`을 VO로 볼 수 있다.<br>

각각의 지폐들은 고유번호거 있다. 천원짜리 지폐가 서로 고유번호가 다르다고 해서 다른 천원으로 보지않고 똑같은 천원으로 본다.<br>
값 그 자체만을 나타내고 값으로만 비교되는 객체를 VO라고 한다.





## DTO vs VO

||DTO|VO|
|----|----|----|
|용도|레이어 간 데이터 전달|값 자체 표현|
|동등 결정|속성값이 모두 같다고 해서 같은 객체가 아니다.|속성값이 모두 같으면 같은 객체이다.|
|가변 / 불변|setter 존재 시 가변.setter 비 존재 시 불변|불변|
|로직|getter/setter외의 로직을 갖지 않는다.|getter / setter외의 로직을 가질 수 있다.|