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

Swift에서는 다른 데이터 타입과 자료교환은 암시적으로 절대 불가능하다.

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

## **String** 

String은 문자열을 담는 타입이다.

+ 연산자를 통하여 문자열을 더해 줄 수 있다.

Character타입에 변수를 String에 담을 시 타입이 일치하지 않기 때문에 에러가 발생한다.

```swift
    var someString: String = "러블리즈  "
    someString = someString + " 류수정 👍🏻"

    // String문자열 타입에  Character(문자) 타입을 대입할 시 타입이 맞지 않다.
    someString = someCharacter // (X)
```


# Any, AnyObject, nil

기본 데이터 타입은 아니지만, 기본 데이터 타입 위치에서 특별한 역할을 수행하는 키워드들을 알아보자.

##  Any

Swift의 모든 타입을 지칭하는 키워드이다.

더블 타입에 값을 담고 있는 Any타입에 someAny 변수에 값을 Double 타입인 someDouble 변수에 대입 시 `error: cannot convert value of type 'Any' to specified type 'Double'`

```swift
    var someAny: Any = 100
    someAny = "어떤 타입이든 수용이 가능하다."
    someAny = 123.12

    // let someDouble: Double = somAny
```


## **AnyObject**

- 모든 클래스 타입을 지칭하는 프로토콜

인스턴스타입이 아닌 다른 타입을 대입할 경우 `error: value of type 'Double' does not conform to 'AnyObject' in assignment`

```swift
    class SomeClass {}

    // SomeClass()인스턴스를 생성 후 someAnyObject 변수에 담았다.
    var someAnyObject: AnyObject = SomeClass() 

    // someAnyObject변수에 인스턴스가 아닌 Double형을 넣을 경우 
    someAnyObject = 123.12
```

- nil

    - 없음을 의미하는 키워드


# **컬렉션 타입**

```swift
    // 빈 Int Array 생성
    var integers: Array<Int> = Array<Int>()
    // 
    integers.append(1)
    integers.append(100)
    //integers.append(101.1) // integer에는 실수를 넣을 수 없음(X)

    integers.contains(100) // 100이라는 값이 포함이 되어있는지?
    integers.contains(99) // 

    // 0번 인덱스에 있는 값을 없애 달라
    integers.remove(at: 0)
    // 마지막 요소를 없애는 것
    integers.removeLast()
    // 모두 없애기 
    integers.removeAll()
    // intgers에 몇개가 들어있는지 확인
    integers.count
```

**Array를 표현할 수 있는 다양한 방법들**

```swift
    //Array<Double>와 [Double]은 동일한 표현이다.
    // 빈 Double Array 생성
    var double: Array<Double> = [Double]()

    // 빈 String Array 생성
    var strings: [String] = [String]()

    // 빈 Character Array 생성
    // []는 새로운 빈 Array(축약형)
    var characters: [Character] = []

    // let을 사용하여 Array를 선언하면 불변 Array
    let immutableArray = [1,2,3]
    // let은 변경이 불가능하기 때문에 append 및 remove를 할 수 없다.
```


### Dictionary

요소들이 순서없이 키와 값에 쌍으로 구성되는 컬렉션 타입이다.

```swift
    // Key가 String 타입이고 Value가 Any인 빈 Dictionary 생성
    var anyDictionary: Dictionary<String, Any> = [String: Any]()
    anyDictionary["someKey"] = "value"
    anyDictionary["anotherKey"] = 100

    anyDictionary // ["someKey": "value", "anotherKey": 100]
    // key에 대한 값을 변경 할 수 있다.
    anyDictionary["someKey"] = "dictionary"
    anyDictionary // ["someKey": "dictionary", "anotherKey": 100]

    // key에 대한 값을 없애고 싶을 때
    anyDictionary.removeValue(forKey: "anotherKey")

    // key에 대한 값을 없애고 싶을 때
    anyDictionary["someKey"] = nil


    let emptyDictionary: [String: String] = [ : ]
    let initalizedDictionary: [String: String] = ["name": "jangilkyu", "gender" : "male"]
```

### Set

순서가 없고 멤버가 유일한 것을 보장하는 컬렉션 타입이다.

```swift

// Set은 축약형은 따로 없고 아래와 같이 사용하면 된다.
var set: Set = Set<Int>()

// 값 추가
set.insert(10)
set.insert(20)
set.insert(30)
set.insert(30)
set.insert(30)
set

// 결과
{20,10,30} // 중복값을 제외된다.

// 값삭제
set.remove(20)

// 결과
{10, 30}
```


# 함수 기본

함수는 작업의 가장 작은 단위이자 코드의 집합이다.

## 함수 선언

```swift
   func 함수이름(매개변수1이름: 매개변수1타입, 매개변수2이름: 매개변수2타입) -> 반환 타입{
       함수 구현 부

        return 반환 값
   }
```

## 반환되는 값이 없는 함수

```swift
   func printMyName(name: String) -> Void {
       print(name)
   }

   printMyName(String: "장일규")
```

## 반환되는 값이 있는 함수

```swift
    func sum(a: Int,b: Int) -> Int {
        return a + b
    }

    sum(a: 3, b: 2)
```

## 매개변수와 반환값이 전부 없는 경우

```swift
    func hello() -> Void {
        print("hello")
    }

    hello()
```


# 함수 고급

- **매개변수 기본 값**

 기본값을  갖는 매개변수는 매개변수 목록 중에 뒤쪽에 위치하는 것이 좋다.

```swift
    func greeting(friend: String, me: String = "jangilkyu") {
        print("Hello \(friend)! I'm \(me)")
    }

    // 매개변수 기본값을 가지는 매개변수는 생략이 가능
    greeting(friend: "sujung") // Hello sujung! I'm jangilkyu
```

- 전달인자 레이블

**전달인자 레이블**은 함수를 호출할 때에 매개변수의 역할을 더 명확하게 하거나 함수 사용자의 입장에서 표현하고자 할때 사용

```swift
    func greeting(to friend: String, from me: String){
        print("Hello \(friend)! I'm \(me)")
    }

    // 함수 호출 시 전달인자 레이블 사용해야함
    greeting(to: "sujung",from: "ilkyu")
```


**가변 매개변수**

매개변수로 전달될 값들에 갯수가 명확치 않을 시 가변 매개변수를 사용할 수 있다.

매개변수 뒤에 `...` 마침표 3개를 찍으면된다.

함수당 하나만 가질 수 있다.

```swift
    func sayHelloToFriends(me: String, friends: String...) -> String {
        return "Hello \(friends)! I'm \(me)!"
    }

    print(sayHelloToFriends(me: "jangilkyu", friends: "sujung", "mina", "chulsu")) //Hello ["sujung", "mina", "chulsu"]! I'm jangilkyu!
    print(sayHelloToFriends(me: "ilkyu")) //Hello []! I'm ilkyu!
```

# 조건문

```swift
/*
    if 조건식 {
        실행할 구문
    }
*/
```

# 반복문

## for문

### 1~4범위를 순회

```swift
    for i in 1...4 {
        print(i)
    }

    // 결과
    /*
        1
        2
        3
        4
    */
```

### 배열을 순회

```swift
    let array = [1,2,3,4,5]

    for i in array {
        print(i)
    }
```

## while문

```swift
    var number = 5

    while number < 10 {
        number+=1
    }

    number

    // 결과
    // 10
```