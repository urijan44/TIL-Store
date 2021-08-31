# Palindromes

>Reference [Swift Algorithm Club](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Palindromes)

Palindromes를 굳이 번역하면 사전 의미로 '회문'인데 앞 뒤가 똑같은 '단어'를 뜻한다. '일요일' 같이 앞으로 읽으나 뒤로 읽으나 같은 말이 된다.

코테 문제로 3번이나 본 문자 관련 단골 소재로 보인다.

```Swift
import Foundation
func isPalindrome(_ str: String) -> Bool {
  let strippedString = str.replacingOccurrences(of: "\\W", with: "", options: .regularExpression, range: nil)
  let length = strippedString.count
  
  if length > 1 {
    return palindrome(strippedString.lowercased(), left: 0, right: length - 1)
  }
  return false
}

private func palindrome(_ str: String, left: Int, right: Int) -> Bool {
  if left >= right {
    return true
  }
  
  let lhs = str[str.index(str.startIndex, offsetBy: left)]
  let rhs = str[str.index(str.startIndex, offsetBy: right)]
  
  if lhs != rhs {
    return false
  }
  
  return palindrome(str, left: left + 1, right: right - 1)
}
```

알고리즘 자체는 되게 별거 없다.

문자열이 주어지면 가장 앞 문자와 가장 뒤 문자를 비교 하며 각각의 인덱스가 교차할 때 까지 false문이 안나오면 true를 리턴하게 된다.

