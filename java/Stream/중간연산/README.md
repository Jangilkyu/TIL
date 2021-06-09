# 스트림의 연산 - 중간 연산

👉 **<스트림의 중간 연산자>**

|중간연산|설명|
|:----:|:----:|
|Stream<T> distinct()|중복을 제거|
|Stream<T> filter(Predicate<T> predicate)| 조건에 안 맞는 요소 제외|
|Stream<T> limit (long maxSize)|스트림의 일부를 잘라낸다|
|Stream<T> skip(long n)|스트림의 일부를 건너뛴다.|
|Stream<T> peek(Consumer<T> action)|스트림의 요소에 작업을 수행|
|Stream<T> sorted()|스트림의 요소를 정렬한다.
|Stream<T> sorted(Comparator<T> comparator)|스트림의 요소를 정렬한다.|

👉 **<스트림의 요소를 변환한다.>**

|중간연산|설명|
|:----:|:----:|
|Stream<R>| map(Function<T,R> mapper)|
|DoubleStream |mapToDouble(ToDoubleFunction<T> mapper)|
|IntStream|mapToInt(ToIntFunction<T> mapper)|
|LongStream|mapToLong(ToLongFunction<T> mapper)|
|Stream<R>|flatMap(Function<T,Stream<R>> mapper)|
|DoubleStream|flatMapToDouble(Function<T.DoubleStream> m)|
|IntStream|flatMapToInt(Function<T, IntStream> m)|
|LongStream|flatMapToLong(Function<T,LongStream> m)|

👉 **<스트림 자르기>**

- skip()
- limit()

```java
Stream<T> skip(long n) // 앞에서부터 n개 건너뛰기
Stream<T> limit(long maxSize) // maxSize 이후의 요소는 잘라냄


// skip과 limit사용
IntStream intStream = IntStream.rangeClose(1,10);  // 1부터 10까지 포함
// 3개 건너뛰고 5개만 출력한다.
intStream.skip(3).limit(5).forEach(System.out::print); // 45678
```

👉 **<스트림의 요소 걸러내기>**

- filter()
- distinct()

```java
Stream<T> filter(Predicate<? super T> predicate) // 조건에 맞지 않는 요소 제거
Stream<T> distinct() // 중복 제거

// distinct()
IntStream intStream = IntStream.of(1,2,3,3,4,4,5,6); // 1 2 3 4 5 6
intStream.distinct().forEach(System.out::print);

IntStream intStream = IntStream.rangeClosed(1,10); // 1 2 3 4 5 6 7 8 9 10
intStream.filter(i -> i % 2 == 0).forEach(System.out::print); // 2 4 6 8 10

intStream.filter(i -> i%2 != 0 && i % 3 != 0).forEach(System.out::print);
intStream.filter(i -> i%2 != 0).filter(i->i%3 != 0).forEach(System.out.print);
```

👉 **<스트림 정렬하기>**

- sorted()

```java
Stream<T> sorted() // 스트림 요소의 기본 정렬(Comparable)로 정렬
Stream<T> sorted(Comparator<? super T> comparator) // 지정된 Comparator로 정렬 
```

👉 <스트림의 요소 변환하기>

- map()

```java
Stream<R> map (Function<? super T,? extends R> mapper) // Stream<T> -> Stream<R>


// FIle클래스 객체들을 String으로 변환
Stream<File> fileStream = Stream.of(new File("Ex1.java")), new File("Ex2.java");

Stream<String> filenameStream = fileStream.map(File::getName);
filenameStream.forEach(System.out::println); // 스트림의 모든 파일의 이름을 출력
```

👉 <스트림의 요소를 소비하지 않고 엿보기>

- peek()
    - 중간 작업 결과를 확인하고 싶을때 디버깅용으로 사용

```java
Stream<T> peek(Consumer<? super T> action) // 중간 연산(스트림을 소비하지않음)
void forEach(Consumer<? super T action> action) // 최종 연산(스트림을 소비함)

fileStream.map(File::getName) // Stream<File> -> Stream<String>
          .filter(s -> s.indexOf('.') != -1 ) // 확장자가 없는 것은 제외
          .peek(s -> System.out.printf("filtename=%s%n",s)) // 파일명을 출력
          .map(s -> s.substring(s.indexOf('.')+1)) //확장자만 추출
          .peek(s-> System.out.printf("extension=%s%n",s)) //확장자를 출력한다.
          .forEach(System.out::println); // 최종연산 스트림을 소비
```
