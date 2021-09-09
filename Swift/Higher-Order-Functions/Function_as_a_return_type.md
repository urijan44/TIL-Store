# 함수 반환형

>[Reference Expert Swift by raywenderlich Tutorial Team](https://www.amazon.com/Expert-Swift-First-Advanced-Exploration/dp/195032544X)

## 커링(Currying)

```Swift
func aHigherOrderFunction(_ operation: (Int) -> ()) {
  let numbers = 1...10
  numbers.forEach(operation)
}

func someOperation(_ p1: Int, _ p2: String) {
  print("number is : \(p1), and String is: \(p2)")
}
```
위와 같은 함수가 있을 때 `aHigherOrderFunction`은 정수를 파라메터로 가지고 리턴타입이 Void인 함수를 인자로 받는다.

`someOperation`은 정수와 문자열을 인자로 하는 함수로 일반적으로는 요구하는 인자가 일치하지 않기 때문에 `aHigherOrderFunction`에 사용할 수 없다. (불가능 하지 않다.)

이를 전달하기 위해서는 클로져를 통해서 전달할 수 있다.

```Swift
aHigherOrderFunction { int in
  someOperation(int, "a constant")
}
```
요런 모양으로 사용이 가능하고 축약 하면
```Swift
aHigherOrderFunction { someOperation($0, "a constant") }
```
위와같이 쓸 수 있다.

클로져를 사용하지 않고 사용하기 위해서 currying이라는 것을 할 수 있다.

원래 함수를 분해해서 매개변수를 재정렬 하는 것이다.

**우선은 분해부터**

`someOperation`을 아래와 같이 바꿔서 작성할 수 있다.
```Swift
func curried_SomeOperation(_ p1: Int) -> (String) -> () {
  return { str in
    print("number is: \(p1), and String is: \(str)")
  }
}
```
매개 변수는 정수 하나를 취하고 문자열을 매개 변수로 취하는 클로저를 반환한다. 그리고 클로져는 p1을 캡처해서 반환한다.

위와 같이 분해된 함수는 아래처럼 사용할 수 있다.

```Swift
aHigherOrderFunction { curried_SomeOperation($0)("a constant") }
```
여전히 클로져를 써서 `aHigherOrderFunction`에 전달하기는 하지만 `someOperation` 함수는 매개변수로 정수 하나만 받는다(뒤에 클로져 인자를 받긴 하지만)

### 핵심은 이 과정에서 원래의 함수를 망가트리지 않고 분해를 했다는 것이다.

currying의 마무리는 이를 재정렬 하는 것이다.

```Swift
func curried_SomeOperation(_ str: String) -> (Int) -> () {
  return { p1 in
    print("number is: \(p1), and String is: \(str)")
  }
}
```
someOperation은 분해를 했었는데 사실 이 순서가 변해도 전혀 상관이 없다. 이렇게 매개변수를 문자열을 받고 반환 타입을 정수를 매개변수로 하는 함수로 반환할 수 있다.

이렇게 되면 `aHigherOrderFunction`에서는 이렇게 호출 할 수 있다.

```Swift
aHigherOrderFunction { curried_SomeOperation("a constant")($0) }
```
여전히 클로져를 쓰고 있긴 하지만 매개변수의 의치를 바꾸었는데 잘 생각해보자

> 어? `curried_SomeOperation`이 문자열을 인자로 주면 (Int) -> ()를 반환하잖아?
> 그러니까 `aHigherOrderFunction`에 인자로 그대로 전달해주면 되네?

`aHigherOrderFunction` 정의를 다시보면 Int를 받아 Void를 반환하는 함수를 인자로 받는다.
```Swift
func aHigherOrderFunction(_ operation: (Int) -> ()) {
  let numbers = 1...10
  numbers.forEach(operation)
}
```

그러면 이렇게 쓸 수 있겠네!

```Swift
aHigherOrderFunction(curried_SomeOperation("a constant"))
```
`curried_SomeOperation`가 (Int) -> ()을 반환해서
`aHigherOrderFunction`의 매개변수 조건인 (Int) -> ()이 되었다.

따라서 위와 같은 코드로 작성되어 결과적으로 클로저를 없애버렸다.

지금까지가 바로 Curry이고 이를 통해 매개변수를 분해하고(원본의 기능을 파괴하거나 하지 않았다.) 순서를 바꾸어서 `aHigherOrderFunction`에서 요구하는 조건을 맞추었다.

그런데 지금까지는 Curried 된 새로운 함수를 만들었는데 그렇다면 함수를 쓸때마다 Curried 버전의 함수를 작성해야 할까? 

아니다 Generic Curry Function을 이용하면 단번에 모두 적용이 가능하다!

>아래 내용은 Swift의 Generic을 사용함으로 Generic에 대한 이해가 필요하다

## A generic currying function

generic currying 함수는 앞서 했던 매개변수의 분해와 매개변수 재정렬을 Generic을 통해서 curry와 filp 두가지 함수로 나누어서 작성한다.

여기서 맨 처음 `someOperation`을 다시 가져오겠다.

```Swift
func someOperation(_ p1: Int, _ p2: String) {
  print("number is : \(p1), and String is: \(p2)")
}
```
이를 Generic으로 표현해보면
`originalMethod(A, B) -> C`이다. 

`someOperation`은 반환유형이 없는데? 라고 생각이 든다면 똑똑한 컴파일러 덕분에 생략해서 사용 중이라는 것을 잊고 있는 것이다.

`someOperation`의 원형은 아래와 같다.

```Swift
func someOperation(_ p1: Int, _ p2: String) -> Void {
  ...
}
```
위 코드를 축약형으로 한번 더 작성하면
```Swift
func someOperation(_ p1: Int, _ p2: String) -> () {
  ...
}
```
이는 원래 우리가 작성했던 코드처럼 -> () 부분을 생략 가능하다
그러니까 `someOperation`은 기술적으로 (A, B) -> C 인 것이다.

다시 본론으로 돌아와서 curry 함수는 `someOperation`을 분해 해버릴 것이다.

```Swift
func curry<A, B, C>(_ originalMethod: @escaping (A, B) -> C) -> (A) -> (B) -> C {
  return { a in
    { b in
      originalMethod(a, b)
    }
  }
}
```

여기서 급발진 해버렸는데 처음 Curry 한 것을 한번 더 체인 한 것 뿐이므로 어렵게 생각하지 말자
@escaping 이 들어갔는데 이는 originalMethod가 Curry 이후에 동작하기 위해서 추가되었다.

이렇게 함으로써 이제 함수를 아래와 같이 작성할 수 있다.

```Swift
//1
someOperation(1, "number one")
//2
curry(someOperation)(1)("number one")
```
함수를 실행해보면 두 줄의 코드는 기능적으로 완전히 동일한데 차이점이라면 아랫줄이 Curry를 통해서 `(Int, String) -> ()` 이던 함수가 `(Int) -> (String) -> ()`가 되었다는 것이다.

이제 여기서 `aHigherOrderFunction`은 매개변수가 `(Int) -> ()`가 되길 원하므로

Curry된 함수를 `(String) -> (Int) -> ()`로 flip 해야한다. 왜냐하면

```Swift
aHigherOrderFunction(curried_SomeOperation("a constant"))
```
Curry된 함수에 String 매개 변수를 전달하면 `(Int) -> ()` 함수를 리턴할 것이기 때문이다.

## Generic argument flipping

Generic Currying만 해도 머리가 아프다는 거 잘 안다. 적어도 나에겐 그렇다.

다행히도 Flip은 그렇게 복잡하지? 않다고 한다.

위에서 flip 한거 한번 더 가져와 보겠다.

기억나는가?

```Swift
func curried_SomeOperation(_ p1: Int) -> (String) -> () {
  return { str in
    print("number is: \(p1), and String is: \(str)")
  }
}
```

위와 같이 분해된 코드 클로져에서

```Swift
func curried_SomeOperation(_ str: String) -> (Int) -> () {
  return { p1 in
    print("number is: \(p1), and String is: \(str)")
  }
}
```

그냥 바꾸어 쓴것이 다임을

Generic Flipping도 그렇다.

```Swift
func flip<A, B, C>(_ originalMethod: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
  return { b in
    { a in
      originalMethod(a)(b)
    }  
  }
}
```
복잡해 보인다면 지금 작업의 목적을 생각해보자.

`(Int) -> (String) -> ()` 인 것을 `(String) -> (Int) -> ()`로 바꾸는 것이다.

A, B, C가 있으면 B, A, C로 바꾼 것일 뿐 어렵게 생각하지 말자.

결과적으로 원래의 함수를 curry하고 flip 해서 (Int) -> () 인자에 맞출 수 있게 되었으므로 코드를 아래처럼 작성할 수 있다.

```Swift
aHigherOrderFunction(flip(curry(someOperation))("a constant"))
```
(재정신인가 ㅎ 😭)

복잡해 졌지만 맨 처음 `curried_SomeOperation` 처럼 함수를 새로 작성하는 일은 없어졌다, Generic을 통해서 일종의 래핑만 하면 원래 함수를 그대로 원하는 규격에 맞추어 넣을 수 있게 되었다.

조금 불편함을 감수하면 커리와 같은 복잡한 행동을 하지 않아도 되지만 코드가 방대해 지게 된다면 그 때 가서라도 써야하니 개념을 알고 넘어가는게 좋을 것 같다.

## Swift의 클래스 메소드와 Flip
Curry도 매개변수를 분해하는 것이 참말로 용이하지만 이 Flip의 경우도 굉장히 유용하다

Swift Standard Libray의 map은 정말정말 유용한 함수인데

나는 보통 이 함수를 사용할 때 항상 클로져를 썼다. 근데 전달하는 기능을 잘 분해하고 조립하면 함수 인자로 넘겨서 깔끔하게 쓸 수 있다!

```Swift
extension Int {
  func word() -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    return formatter.string(from: self as NSNumber)
  }
}

1.word() // one
10.word() // ten
36.word() // thirty-six

```
Swift는 위 메소드에 대해서 고차함수를 생성하는데

```Swift
Int.word // (Int) -> () -> Optional<String>
```
이다.

위 기능을 정수 배열에 전부 적용해서 문자열로 포맷팅된 결과를 얻는다고 하면

```Swift
[1,2,3,4,5].map { $0.word() }
//["one", "two", "three", "four", "five"] (optional)
```
위와 같이 쓸 수 있는데 이를 Flip을 통해서 클로져를 사용하지 않을 수 있다.

Int.word가 `(Int) -> () -> Optional<String>` 인것들 알았는데

이는
```Swift
Int.word(1)() //one
```
과 같다. 만약 얘가 

```Swift
Int.word()(1) //one // () -> (Int) -> Optional<String>
```
이 된다면
`(Int) -> Optional<String>` 부븐을 map의 인자로 집어넣을 수 있게 된다.

```Swift
func flip<A, C>(_ originalMethod: @escaping (A) -> () -> C) -> () -> (A) -> C {
  return { { a in originalMethod(a)()}}
}
```
위 코드가 이해가 안된다면 flip 부분을 좀더 공부해보자

이를 통해서 
```Swift
flip(Int.word)()(1) // one // () -> (Int) -> Optional<String>
```
이 되었다.

```Swift
var flippedWord = flip(Int.word)()
let fliped = [1,2,3,4,5].map(flippedWord)
//["one", "two", "three", "four", "five"
```

이런 방법도 가능하다.
```Swift
func reduce<A, C>(
  _ originalMethod: @escaping (A) -> () -> C) -> (A) -> C {
  return { a in originalMethod(a)() }
}

var reducedWord = reduce(Int.word)
```

## 고차 함수 병합
이제 정말 별 짓이 다 가능한데 flip을 통해서 함수의 병합이 가능하다.

```Swift
extension Int {
  func word() -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    return formatter.string(from: self as NSNumber)
  }

  func squared() -> Int {
    return self * self
  }
}
```
위의 확장된 두 함수를 고려하자
squared() 된 정수를 word 한다고 하면

```Swift
func mergeSquareAndWord() -> String? {
  self.squared().word() //nine
}

```
요런 꼬라지가 가능한데 물론 함수를 결합하긴 했지만 결합하고 싶은 함수가 2개 보다 많거나 매게변수의 순서가 맞지 않으면 결합이 되지 않는다.

논리적으로 생각해보면

squared()는 (Int) -> () -> Int이고

word()는 (Int) -> () -> String? 이다.

이를 함수로 만들면

```Swift
func mergeFunctions<A, B, C>(
  _ squared: @escaping (A) -> () -> B,
  _ word: @escaping (B) -> () -> C
) -> (A) -> C {
  return { a in
    let fValue = squared(a)()
    return word(fValue)()
  }
}
```
위와 같이 작성할 수 있다. 각각 사용하는게 Int랑 String?, () 밖에 없는데 제네릭 인자가 3개인게 의아할 수 있는데 아래 처럼 써도 똑같이 동작한다.

```Swift
func mergeFunctions<A, C>(
  _ squared: @escaping (A) -> () -> A,
  _ word: @escaping (A) -> () -> C
) -> (A) -> C {
  return { a in
    let fValue = squared(a)()
    return word(fValue)()
  }
}
```

```Swift
var mergedFunctions = mergeFunctions(Int.squared, Int.word)

mergedFunctions(4) // sixteen
```

이를 더 축약 하는 방법이 있는데 `Function Composition`이라는 기법이다.

연산자 오버로딩을 활용하는 것으로

```Swift
func +<A, B, C>(
  left: @escaping (A) -> () -> B,
  right: @escaping (B) -> () -> C
) -> (A) -> C {
  return { a in
    let leftValue = left(a)()
    return right(leftValue)()
  }
}
```
위와 같이 코드를 작성하면
```Swift
var addedFunctions = Int.squared + Int.word
addedFunctions(2) // four
(Int.squared + Int.word)(2) // four
```
`+` 연산자를 함수 기능을 합치는 연산자로 사용할 수 있다!


## 후기
문서로 정리하길 정말 잘했다는 생각이 든다. 오래 걸렸지만 처음 눈으로 읽었을 때는 전혀 이해하지 못했다.
사실 고차함수에 대해서는 Swift.org 에서도 이해를 하지 못해 애먹었는데 이번 기회에 개념은 적립한 것 같다. 반복 사용으로 숙달을 하게 되면 무리없이 사용할 수 있을 것 같다. 

평소에 별 생각없이 사용하던 고차함수들 (map이나 filter 등)의 원리와 좀더 향상된 사용법을 익힐 수 있어서 좋았다.

본 글에서는 반환형 함수에 대해서 이론적이고 기능적인 부분에 대해서만 작성했는데 좀더 응용에 대한 내용을 검색하면 찾을 수 있어서 링크로 남긴다.

[커링이란? - 토미의 개발노트](https://jusung.github.io/Currying/)