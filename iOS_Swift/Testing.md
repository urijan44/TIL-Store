# Testing

>Reference By [Swift Apprentice](https://www.aladin.co.kr/shop/wproduct.aspx?ItemId=278858382)

기능을 추가할 때 기존 논리에 버그를 발생 시킬 수 있는 가능성을 줄이기 위한 방지책으로 단위 테스트라는 개념이 있다.

단위 테스트는 기존 코드가 예상대로 작동하는지 테스트하는 것을 목적으로 하는 코드 피스다. 예를들어 새 계좌에 만원을 입금한 다음 잔액이 만원이 맞는지 확인하는 테스트를 작성해볼 수 있겠다.

기존의 레거시 코드를 확인하거나 코드 인수인계를 받을 때 함부로 기존 코드를 건드리지 않고 이 단위 테스트를 통해 기존 코드가 어떻게 돌아가는지 확인하는데도 유용하겠다.

## 테스트 클래스 만들기
단위 테스트를 작성하려면 우선 XCTest 프레임워크를 가져와야 한다.

```Swift
import XCTest

class BackingTests: XCTestCase {
  ...
}
```

## 테스트 작성
테스트는 코드의 핵심 기능과 일부 에지 케이스를 다루어야 한다. `FIRST`라는 약어는 유용한 단위 테스트를 위한 간결한 기준 세트를 설명한다.

- Fast: 테스트가 빠르게 실행되어야 한다.
- Independent/Isolated: 테스트는 상태를 공유하지 않아야 한다.
- Repeatable: 테스트를 실행할 때마다 동일한 결과를 얻어야 한다.
- Self-validating: 테스트는 완전히 자동화 되어야 한다. 출력은 Pass 또는 Fail 이어야 한다.
Timely: 이상적으로는 테스트하는 코드를 작성하기 전에 테스트를 작성해야 한다.(Test-Driven-Development)

테스트 클래스에 테스트를 추가하는 방법은 어렵지 않다. 우선 테스트 차원해서 작성해보면

```Swift
func testSomething() {
}
```
만 쓰고 

```Swift
BankingTests.defaultTestSuite.run()
```
이라고 작성해 보자 그러면 플레이그라운드에서 다음과 같은 콘솔 내용을 볼 수 있다.

```
Test Suite 'BankingTests' started at ...
Test Case '-[__lldb_expr_2.BankingTests testSomething]' started.
Test Case '-[__lldb_expr_2.BankingTests testSomething]' passed (0.837 seconds).
Test Suite 'BankingTests' passed at ...
   Executed 1 test, with 0 failures (0 unexpected) in 0.837 (0.840) seconds
```
이미 얘기했지만 passed가 표시 되었고 아무작업도 수행하지 않았다.

## XCTAssert
`XCTAssrt`기능은 테스트가 특정 조건을 충족하는지 확인한다. 예를들어 특정 값이 0보다 크거나 객체가 nil인지 확인할 수 있다.

다음 코드는 새 계정이 잔액이 없는 상태로 시작하는 확인하는 방법이다.
```Swift
func testNewAccountBalanceZero() {
  let checkingAccount = CheckingAccount()
  XCTAssertEqual(checkingAccount.balance, 0)
}
```
`XCTAssertEqual`는 매게변수 두개가 서로 같은 값임을 확인한다.

```Swift
func testCheckOverBudgetFails() {
    let checkingAccount = CheckingAccount()
    let check = checkingAccount.writeCheck(amount: 100)
    XCTAssertNil(check)
}
```
이 코드는 수표를 100만큼 쓰고 check가 nil인지 판별한다.

## XCTfail, XCTSkip
특정 전제 조건이 충족되지 않으면 테스트를 실패하도록 선택할 수 있는데 예를들어 iOS 14이상에서만 사용할 수 있는 API를 확인하기 위한 테스트를 작성한다고 가정한다.
```Swift
func testNewAPI() {
    guard #available(iOS 14, *) else {
      XCTFail("Only available in iOS 14 and above")
      return
    }
    // perform test
}
```
또는 테스트를 실패하는 대신 해당 부분을 건너뛸 수도 있다.
```Swift
func testNewAPI() throws {
    guard #available(iOS 14, *) else {
      throw XCTSkip("Only available in iOS 14 and above")
    }
    // perform test
}
```

## @testable
@testable은 모듈을 가져올 때 모듈의 internal을  테스트 하고 싶을 수도 있다. 그러기 위해서 import 앞에 붙이는 키워드 이지만 이는 권장하지 않는다.(private API는 공개되지 않는다.)

## setUP, tearDown 메소드
```Swift
func testCheckOverBudgetFails() {
    let checkingAccount = CheckingAccount()
    let check = checkingAccount.writeCheck(amount: 100)
    XCTAssertNil(check)
}
```
위와 같이 코드를 작성하게 되면 각 테스트 함수마다 새로운 인스턴스를 생성하게 되는데 하나의 인스턴스에서 테스트해야 하는 상황도 있다. 이때 사용하는게 바로 setUp과 tearDown으로 각각 반대의 개념이다.

```Swift
var checkingAccount: CheckingAccount!

override func setUp() {
  super.setUp()
  checkingAccount = CheckingAccount()
}
```
setUp은 위와 같이 다른 테스트 함수를 실행하기 전에 동작하는 것으로 checkingAccount를 인스턴스를 초기화 하거나 할때 쓸 수 있다.

그리고 tearDown은 테스트 함수 후에 실행되는 것으로
```Swift
override func tearDown() {
  checkingAccount.withdraw(amount: checkingAccount.balance)
  super.tearDown()
}
```
위 처럼 작성할 수 있다.
