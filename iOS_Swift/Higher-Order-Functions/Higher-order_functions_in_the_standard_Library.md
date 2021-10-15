# 표준 라이브러리의 고차함수
Swift는 몇가지 유용한 고차함수를 라이브러리 차원에서 제공하는데 흔히들 써봤을 것이다. 그것들 중 일부가 아래와 같다.
- [Map](#map--split)
- [Split](#map,-split)
- [CompactMap](#compactmap)
- [FlatMap](#flat-map)
- [Filter](#filter)
- [Reduce](#reduce)
- [Sorted](#sorted)


## Map, Split
`Array.map(_:)`은 배열의 모든 요소에 대해 작업하고 리턴값으로 동일한 크기의 새 배열을 반환한다. 

백준에서 입력 값을 받을 때 참 많이 유용한데
[백준 1085문제](https://www.acmicpc.net/problem/1085)의 경우 입력 값으로 4개의 정수가 스페이스 문자로 구분되어 들어온다.
>6 2 10 3

문제를 풀때 이를 스페이스 문자로 구분해서 배열로 저장하고 문자로 들어온 것이기 때문에 정수로 변경해야 하는데 map을 사용하지 않으면

```Swift
let input = readLine()!.split(separator: " ")
var convertInteger: [Int] = []

for number in input {
  convertInteger.append(Int(number)!)
}
```
변수도 두개나 선언하고 For-in 까지 사용해서 코드가 길어지는데 map을 이용하면 이를 간결하게 만들 수 있다.

```Swift
let input = readLine()!.split(separator: " ").map { Int($0)! }
```

## CompactMap
CompactMap도 굉장히 유용한 고차함수이다. 이 경우 map과 달리 반환하는 배열이 원래 배열과 크기가 동일하지 않을 수 있다. 왜냐하면 CompactMap은 주로 배열에 섞여있는 nil값을 걸러낼 수 있기 때문이다.
사용법은 Map과 동일하지만 오직 nil이 아닌 값을 언래핑 해서 가져온다.

```Swift
import Foundation

let arr: [String] = ["1","2","3","f", "Hello World", "Four"]

func convertToInt(_ value: String) -> Int? {
  if let value = Int(value) {
    return value
  } else {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    return formatter.number(from: value.lowercased()) as? Int
  }
}

let intArr = arr.compactMap(convertToInt(_:))

print(intArr)
//[1, 2, 3, 4]
```

## Flat Map
FlatMap은 이름 그대로 평탄화 하는 작업을 하는데 여러 중첩된 배열을 하위단게의 배열로 변환할 수 있디.

```Swift
import Foundation

let gugudan = [1,2,3,4,5,6,7,8,9]

func calculateGugudan(_ number: Int) -> [Int] {
  var table: [Int] = []
  for i in 1...9 {
    table.append(number * i)
  }
  return table
}

let gugudanTable = gugudan.map(calculateGugudan(_:))
               
print(gugudanTable)
//[[1, 2, 3, 4, 5, 6, 7, 8, 9], [2, 4, 6, 8, 10, 12, 14, 16, 18], [3, 6, 9, 12, 15, 18, 21, 24, 27], [4, 8, 12, 16, 20, 24, 28, 32, 36], [5, 10, 15, 20, 25, 30, 35, 40, 45], [6, 12, 18, 24, 30, 36, 42, 48, 54], [7, 14, 21, 28, 35, 42, 49, 56, 63], [8, 16, 24, 32, 40, 48, 56, 64, 72], [9, 18, 27, 36, 45, 54, 63, 72, 81]]

let joinGugudanTable = Array(gugudanTable.joined())
//[1, 2, 3, 4, 5, 6, 7, 8, 9, 2, 4, 6, 8, 10, 12, 14, 16, 18, 3, 6, 9, 12, 15, 18, 21, 24, 27, 4, 8, 12, 16, 20, 24, 28, 32, 36, 5, 10, 15, 20, 25, 30, 35, 40, 45, 6, 12, 18, 24, 30, 36, 42, 48, 54, 7, 14, 21, 28, 35, 42, 49, 56, 63, 8, 16, 24, 32, 40, 48, 56, 64, 72, 9, 18, 27, 36, 45, 54, 63, 72, 81]
```
구구단 테이블을 이중 배열로 만들고 난뒤 해당 테이블을 joined 메소드를 통해서 1차원 배열로 변환 할 수 있지만 처음부터 1차원 배열이 목적이라면 flatMap이 훨씬 짧고 간결하게 사용할 수 있다.

```Swift
import Foundation

let gugudan = [1,2,3,4,5,6,7,8,9]

func calculateGugudan(_ number: Int) -> [Int] {
  var table: [Int] = []
  for i in 1...9 {
    table.append(number * i)
  }
  return table
}

let flatMapGugudanTable = gugudan.flatMap(calculateGugudan(_:))
```

## Filter
Filter 함수도 정말정말 유용하고 쉬운 함수중 하나이다.
배열에서 원하는 조건에 맞는 값만 말 그대로 필터링 가능한 함수
```Swift
import Foundation

func intToWord(_ number: Int) -> String? {
  let formatter = NumberFormatter()
  formatter.numberStyle = .spellOut
  return formatter.string(from: number as NSNumber)
}

let numbers: [Int] = Array(0...100)
let words = numbers.compactMap(intToWord(_:))
// ["zero", "one", "two", ....., "ninety-nine", "one hundred"]
func shouldKeep(word: String) -> Bool {
  return word.count == 4
}
let filteredWords = words.filter(shouldKeep(word:))
// ["zero", "four", "five", "nine"]
```

## Reduce
Reduce는 배열의 요소들을 병합할 때 편리한 방법으로 또 흔하게 쓰는 부분이 있다.
```Swift
let numbers = Array(1...10)
let sum = numbers.reduce(0, +)
//sum 55
```
1에서 10까지의 숫자의 합을 sum에다 저장하는데 sum은 Int자료형으로 55를 저장했다.

이게 가능한 이유는 Reduce의 파라메터가 함수를 받기 때문이다. Swift 에서 오퍼레이터는 객체 내에 타입 메소드로 정의되어 있는데

>Swift 에서 Int 자료형의 정의를 살펴보면
```Swift
/// Adds two values and produces their sum.
    ///
    /// The addition operator (`+`) calculates the sum of its two arguments. For
    /// example:
    ///
    ///     1 + 2                   // 3
    ///     -10 + 15                // 5
    ///     -15 + -5                // -20
    ///     21.5 + 3.25             // 24.75
    ///
    /// You cannot use `+` with arguments of different types. To add values of
    /// different types, convert one of the values to the other value's type.
    ///
    ///     let x: Int8 = 21
    ///     let y: Int = 1000000
    ///     Int(x) + y              // 1000021
    ///
    /// The sum of the two arguments must be representable in the arguments'
    /// type. In the following example, the result of `21 + 120` is greater than
    /// the maximum representable `Int8` value:
    ///
    ///     x + 120                 // Overflow error
    ///
    /// - Note: Overflow checking is not performed in `-Ounchecked` builds.
    ///
    /// If you want to opt out of overflow checking and wrap the result in case
    /// of any overflow, use the overflow addition operator (`&+`).
    ///
    ///     x &+ 120                // -115
    ///
    /// - Parameters:
    ///   - lhs: The first value to add.
    ///   - rhs: The second value to add.
    public static func + (lhs: Int, rhs: Int) -> Int
    ```

위와 같이 정이 되어 있기 때문에 따라서 코드를 이렇게도 쓸 수 있다.
```Swift
import Foundation

let numbers = Array(1...10)

func 더하기(_ lhs: Int, _ rhs: Int) -> Int {
  return lhs + rhs
}

let sum = numbers.reduce(0, 더하기(_:_:))
//sum 55
```

## Sorted
정렬 함수는 거의 필수 함수처럼 사용하고 있어서 이게 고차함수라는 생각도 안해보고 사용한 경우가 많은 것 같다.

```Swift
let numbers = [0, 5,4,0,7,1,0,2,5,7,2,0]

func zeroIsLast(_ lhs: Int, _ rhs: Int) -> Bool {
  if lhs == 0 {
    return false
  }
  if rhs == 0 {
    return true
  }
  return lhs < rhs
}

let sortedNumbers = numbers.sorted(by: sevenIsLast(_:_:))
```
평범하게 사용한다면 숫자나 문자를 오름차순, 내림차순으로도 가볍게 사용할 수 있고
고차함수로 사용하게 되면 특정 조건에서 다르게 동작하는 정렬 함수를 만들 수도 있다,.
