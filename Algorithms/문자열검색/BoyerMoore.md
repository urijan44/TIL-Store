# Boyer Moore 문자열 검색 알고리즘

>Reference [Swift Algorithm Club](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Boyer-Moore-Horspool)

Boyer Moore 문자열 검색 알고리즘은 모든 문자열 검색의 벤치마크로 사용된다고 한다. (구현도 쉽고 아이디어도 되게 쉽다 그래서 더욱 놀랍다)

Boyer Moore 문자열 검색 알고리즘의 기본 컨셉은 이렇다.

1. 문자열의 뒤에서 부터 문자 끼리 비교한다.
2. 문자가 Skip Table에 있으면 스킵한다.

`Skip Table`이라는 것이 핵심 키워드 이다. 무슨 얘기인고 하니

```Swift
검색 문자열 "LELEHOOHELWEHELLOLLO"
타겟 문자열 "HELLO"
```
검색 문자열 에서 타겟 문자열을 찾는다고 하자
본 알고리즘의 첫번째 컨셉은 문자열을 뒤에서 부터 검색한다고 하자

```Swift
검색 문자열 "LELEHOOHELWEHELLOLLO"
타겟 문자열 "       ^            "
```
설명의 우선 편의를 위해서 앞부분은 건너뛰었다.
순차적으로 문자를 검색하던 중 `H`를 확인하게 되었는데
타겟 문자열 `HELLO`는 H가 문자열 첫번째에 위치 해있다.
그래서 ELLO 만큼 건너 뛰어서 확인해야 하는 케이스를 줄일 수 있다.
```Swift
검색 문자열 "LELEHOOHELWEHELLOLLO"
타겟 문자열 "       HELLO        "
```

```Swift
검색 문자열 "LELEHOOHELWEHELLOLLO"
타겟 문자열 "           ^-----   "
```
현재 비교하는 인덱스는 E이고 다음 인덱스는 H이다.
원래 기존 방식대로 하면 H부터 O까지 한 칸씩 이동하며 패턴 문자열과 같은지 확인해야 하지만 앞서 말한 Skip Table이라는 것 덕분에 한칸씩 이동할 필요 없이

```Swift
검색 문자열 "LELEHOOHELWEHELLOLLO"
타겟 문자열 "            HELLO   "
```
단번에 이동할 수 있다.

전체 코드
```Swift
extension String {
  
  //Skip table
  fileprivate var skipTable: [Character: Int] {
    var skipTable: [Character: Int] = [:]
    
    for (i, c) in enumerated() {
      skipTable[c] = count - 1 - i
    }
    return skipTable
  }
  
  //뒤에서 부터 문자열 매치 확인하는 메소드
  fileprivate func match(from currentIndex: Index, with pattern: String) -> Index? {
    
    if currentIndex < startIndex { return nil }
    if currentIndex >= endIndex { return nil }
    
    if self[currentIndex] != pattern.last! { return nil }
    
    if pattern.count == 1 && self[currentIndex] == pattern.last { return currentIndex }
    
    return match(from: index(before: currentIndex), with: "\(pattern.dropLast())")
  }
  
  //메인 메소드 
  func index(of pattern: String) -> Index? {
    let patternLength = pattern.count
    guard patternLength > 0, patternLength <= count else { return nil }
    
    let skipTable = pattern.skipTable
    let lashChar = pattern.last!
    
    var i = index(startIndex, offsetBy: patternLength - 1)
    //문자열을 뒤에서 부터 검색하기 때문에
    //시작 인덱스가 패턴의 문자열 길이만큼 뛰어서 시작한다.
    
    while i < endIndex {
      let c = self[i]
      //마지막 문자열이 일치할 경우 뒤에서 매치 메소드 호출
      if c == lashChar {
        if let k = match(from: i, with: pattern) { return k }
        i = index(after: i)
      } else {
        // SkipTable에 있는 문자의 경우 인덱스 이동
        i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
        // 없는 경우는 패턴문자열의 길이만큼 이동
      }
    }
    return nil
  }
}
```