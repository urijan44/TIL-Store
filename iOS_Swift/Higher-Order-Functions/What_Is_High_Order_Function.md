# 함수 타입에 대해
> Reference Raywenderlich High Order Functions in Swift

고차 함수에 대한 개념은 Swift 문법을 처음 공부할 때 많이 접해보긴 했는데 사용법이 '쉽지'는 않아서 개념만 알고있긴 하다.
하지만 Swift를 사용한다면 거의 무조건 사용해보았을 것인데 대표적으로 Apple API 중 메소드가 **핸들러**를 가지고 있는 경우와 SwiftUI의 ViewBuilder, Combine이 있다.

Swift는 Type Safety 언어로 코드를 컴파일 할 때 타입 검사를 실시한다. 다르게 생각하자면 Swift에서 만들어 지는 것은 모두 Type이 있다고 볼 수 있다.
구조체, 클래스, 열거형, 프로토콜 모두 Name type이다.
Name type은 정의할 때 이름을 지정해야 하는데 이는 당연히 하던 것들이다.

```Swift
protocol Bicycle {
  func changeGear(up: Bool) -> Bool
}
struct Roadbike: Bicycle {
  var spraketGear: Int
  
  func changeGear(up: Bool) -> Bool {
    if up && spraketGear > 11 {
      return true
    }
    return false
  }
}
```
위 코드에서 프로토콜을 이름을 `Bicycle`로 정의하고, `Roadbike` 구조체를 정의하고 프로퍼티 이름을 정의한 것이 이에 해당한다. 

`changeGear`라는 함수도 이름을 정의했다. 그런데 모든 함수가 이름이 있는 것은 아니다.
함수에 이름이 있는 경우는 함수 타입이 아니다.
함수는 복합 유형(Compound Type)으로 이름을 지어 사용하는 대신 구성되는 타입에 따라 정의된다.

위 코드의 `changeGear`는 파라메터 타입이 있고 리턴 타입이 있는 함수로 이를 **First order function**(1차 함수) 이다.

그러면 **High Order Function**(고차함수)의 정의는 뭘까

고차함수는 파라메터 타입으로 함수를 취하거나 또는 리턴 타입으로 함수를 취하는 경우이다.

>[Swift.org 언어 가이드 함수](https://bbiguduk.gitbook.io/swift/language-guide-1/functions)

고차함수는 코드를 더 읽기 쉽고, 짧고, 재상용이 용이하게 만든다.

예제를 통해 확인해보자

```Swift
let exampleSentences = [
  "this is an example",
  "Another example!!",
  "one more example, here",
  "what about this example?"
]

extension Array where Element == String {
  func format(_ sentence: String) ->String {
    guard !sentence.isEmpty else { return sentence }
    var formattedSentence = sentence.prefix(1).uppercased() + sentence.dropFirst()
    if let lastCharacter = formattedSentence.last, !lastCharacter.isPunctuation {
      formattedSentence += "."
    }
    return formattedSentence
  }

  func printFormatted() {
    for string in self {
      let formattedString = format(string)
      print(formattedString)
    }
  }
}

exampleSentences.printFormatted()
//This is an example.
//Another example!!
//One more example, here.
//What about this example?
```
우선 코드를 확인해보면, `format` 메소드는 문자열을 입력받으면 해당 문자열의 첫 문자를 대문자로 바꾸고 마지막 문자가 구두점이 아닐경우 점을 추가한다.
그리고 `printFormatted` 배열에 저장된 문자열을 앞서 정의한 `format` 메소드로 format을 변경한 다음 print 함수로 출력한다.
위 코드는 1차 함수의 표본이다.

그런데 만약에 더 많은 포멧 방법을 제시하고 이를 `printFormatted`로 전달하고 싶으면 어떻게 해야할까? 일일이 `printFormatted`에서 케이스 별로 처리해 줘야 하는걸까?

이를 고차함수가 손쉽고 빠르게 해결해 준다.

```Swift
func format(_ sentence: String) ->String {
  guard !sentence.isEmpty else { return sentence }
  var formattedSentence = sentence.prefix(1).uppercased() + sentence.dropFirst()
  if let lastCharacter = formattedSentence.last, !lastCharacter.isPunctuation {
    formattedSentence += "."
  }
  return formattedSentence
}
```

```Swift
extension Array where Element == String {
  func printFormatted(formatter: (String) -> String) {
    for string in self {
      let formattedString = formatter(string)
      print(formattedString)
    }
  }
}
```

처음 코드와 다른 것은 `format` 를 밖으로 꺼낸 함수로 두었고
Array extension안의 `printFormatted` 메소드는 파라메터가 바뀌었다.

`(String) -> String)` 가 못보던 코드 일 것이다. 이것의 의미는
String을 파라메터로 받아 String을 리턴 하는 함수를 printFormatted의 파라메터로 한다는 뜻이다.

즉 위와 같이 코드를 구성하게 되면 아래와 같이 작성할 수 있다.

```Swift
exampleSentences.printFormatted(formatter: format(_:))
// Will print out 
//This is an example.
//Another example!!
//One more example, here.
//What about this example?
```
처음과 결과가 동일하게 나온다. 이것이 고차함수다 
`(String) -> String` 즉 String을 파라메터로 받아 String을 반환하는 함수(여기서는 format 함수)를 `printFormatted` 가 파라메터로 받아 처리했다.

이제 다른 포맷을 변경하고 싶으면 format과 같은 함수를 여러개 선언해서 동일한 방법으로 `printFormatted`메소드의 파라메터로 전달하면 된다. `printFormatted`는 전혀 건드릴 필요가 없게 된 것이다. 새로 정의하는 포멧 함수들이 `(String) -> String` 형태를 취하기만 하면 된다.

