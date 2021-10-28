# Protocol Oriented Programming

## Protocol extension dispatch
프로토콜 확장을 사용할 때 주의해야 할 점으로 타입을 프로토콜 자체에서 선언하지 않고 프로토콜 확장에서 선언하는 경우 정적 디스패치가 동작하게 된다. 정적 디스패치는 컴파일러가 유형에 대해 알고 있는 정보를 기반으로 컴파일 타임에 사용되는 속성을 선택하는 것을 의미한다. 컴파일러는 동적 런타임 정보를 고려하지 않는다.

예시
```Swift
protocol WinLoss {
  var wins: Int { get }
  var losses: Int { get }
}

extension WinLoss {
  var winningPercentage: Double {
    Double(wins) / Double(win + losses)
  }
}

struct CricketRecord: WinLoss {
  var wins: Int
  var losses: Int
  var draws: Int

  var winningPercentage: Double {
    Double(wins) / Double(wins + losses + draws)
  }
}

let miamiTuples = CricketRecord(wins: 8, losses: 7, draws: 1)
let winLoss: WinLoss = miamiTuples

miamiTuples.winningPercentage // 0.5
winLoss.winningPercentage // 0.53 !!!
```
winLoss에 miamiTuples를 전달했지만