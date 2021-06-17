# Optional API

## Optional 만들기

- Optional.of()
    - value가 null인 경우 NPE 예외를 던진다. 반드시 값이 있어야 하는 객체인 경우에 해당 메서드를 사용한다.
- Optional.ofNullable()
    - value가 null 인 경우 비어있는 Optional을 반환한다. 값이 null 일수도 있는 것은 해당 메서드를 사용하면 된다.
- Optional.empty()
    - 비어있는 옵셔널 객체를 생성한다. 조건에 따라 분기를 태워야하고 반환할 값이 없는 경우에도 사용된다.

## Optional에 값이 있는지 없는지 확인하기

- isPresent()

- isEmpty()
    - Java 11 부터 제공

## Optional에 있는 값 가져오기
- get()

## Optional에 값이 있는 경우에 그 값을 가지고 ~~를 하라.
-  ifPresent(Consumer)
    - 예) Spring으로 시작하는 수업이 있으면 id를 출력하라.

## Optional에 값이 있으면 가져오고 없는 경우에 ~~를 리턴하라. 
- orElse(T)
    - 예) JPA로 시작하는 수업이 없다면 비어있는 수업을 리턴하라.

## Optional에 값이 있으면 가져오고 없는 경우에 ~~를 하라.
- orElseGet(Supplier)
    - 예) JPA로 시작하는 수업이 없다면 새로 만들어서 리턴하라.
## Optional에 값이 있으면 가졍고 없는 경우 에러를 던져라. 
- orElseThrow()

## Optional에 들어있는 값 걸러내기 
- Optional filter(Predicate)
