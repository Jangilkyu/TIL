# 이름짓기 규칙

- Loweer Camel Case : function, method, variable, constant
    - someVariableName

- Upper Camel Case : type(class, struct, enum, extension)
    - Person, Point, Week

- 대소문자를 구분한다.

# 콘솔로그

- print : 단순 문자열 출력
- dump : 인스턴스의 자세한 설명(description 프로퍼티)까지 출력


# 상수 와 변수

- **상수**를 선언하는 키워드는 **let**이다.
    - let 이름: 타입 = 값
- **변수**를 선언하는 키워드는 **var**이다.
    - var 이름: 타입 = 값

```swift
    // 값의 타입이 명확할 시 타입은 생략이 가능하다.
    let 이름 = 값
    var 이름 = 값

    let constant: String = "차후에 변경이 불가능한 상수 -> let"
    let variable: String = "차후에 변경이 가능한 변수 -> var"

    constant = "상수는 차후에 값을 변경할 수 없다." // 에러 발생
    variable = "변수는 차후에 다른 값으로 할당 할 수 있다."

    // 상수 선언 후에 나중에 값을 할당하기

    // 나중에 할당 할 경우 상수나 변수는 타입을 꼭 명시하여야한다.
    let sum: Int
    let inputA: Int = 100
    let inputB: Int = 200

    // 선언 후 첫 할당
    sum = inputA + inputB

    // 상수는 첫 할당 이후 값을 바꿀 수 없기 때문에 에러가 발생한다.
    sum = 1 // -> 에러 발생(X)

    // 변수도 차후에 할당하는 것이 가능하다.
    var nickName: String

    nickName = "장일규"

    nickName = "Jangilkyu" // 위에 선언한 변수에 값을 변경이 가능하다(O)

```


# 기본 데이터 타입

Swift에는 7가지에 기본 데이터 타입이 있다.

## Bool

c언어에서 처럼 논리 연산자에 0 과 1을 Bool타입에 대입 할 시 `error: cannot assign value of type 'Int to type 'Bool'`이라는 에러가 발생한다. 

```swift

// Bool
    var someBool: Bool = true
    someBool = false

    // Bool 타입에는 0 과 1로 참 거짓을 판단 할 수 없다.
    someBool = 0 // (X)
    someBool = 1 // (X)
```

##  Int

정수만 담을 수 있다. 100.1과 같은 실수를 담으면 에러를 발생한다.

```swift
    var someInt: Int = -100

    // 정수형 타입에 실수값이 대입 되면 에러가 발생된다.
    someInt = 100.1 // (X)
```

##  UInt

Unsigned Integer, 즉 양의 정수 타입이다.

음수에 값을 대입 시 에러가 발생한다.

```swift
    var someUint: UInt = 100
    
    // 음수에 값을 대입 시 에러가 발생한다.
    someUInt = -100 //(X)
```

## FLoat

Float은 부동소수형 32bit 타입이다.

부동소수형 타입에는 정수 타입 대입이 가능하다.

```swift
    var someFloat: Float = 3.14
    
    someFloat = 3 //(O)
```

## Double

Double은 64bit 부동소수형 타입이다.

정수 타입 대입이 가능하다.

Float타입에 값을 Double에 대입할 시 형이 맞지 않아서 오류가 발생한다.

```swift
    var someDouble: Double = 3.14

    // 정수 값 대입 가능
    someDouble = 3
    // 위에 선언한 Float타입은 대입 시 타입이 맞지 않기 때문에 에러 발생
    someDouble = someFloat // (X)
```


## Character 

Character 타입은 한 문자를 표현하기 위한 타입니다.

유니코드를 사용하기 때문에 유니코드로 표현할 수 있는 모든 문자를 대입할 수 있다.

문자열과 동일하게 큰따옴표로 묶어주면 된다.

문자가 한개가 아닌 "가나다라" 문자열일 경우 Character이 아니기 때문에 에러가 발생된다.

```swift
    var someCharacter: Character = "가"
    someCharacter = "A"

    // Character에는 문자열을 담을 수 없다.
    someCharacter = "가나다라"
```

## String 


```swift

```