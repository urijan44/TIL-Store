# Access Controler(접근제어)

>[Reference by Swift Apprentice](https://www.aladin.co.kr/shop/wproduct.aspx?ItemId=278858382)

프로그래밍시 프로퍼티나 메소드, 이니셜라이저 기타 유형 등을 이용해서 Swift 타입을 선언하고 이러한 요소들을 합쳐 API 인터페이스를 구성한다. 코드가 복잡해지고 인터페이스를 제어하는 과정에서 일명 `도우미 메소드`를 인터페이스 내부에서 사용하는 경우가 있다.

외부에서 이 인터페이스를 사용할 때는 이러한 도우미 메소드는 숨기는 것이 구현의 복잡성을 숨길 수 있다.

또 이 숨겨진 내부 상태는 공개 인터페이스가 항상 유지해야 하는 불변성을 유지하게 하는 일명 `캡슐화`로 알려진 기본적인 소프트웨어 설계 개념이다.

## 접근 제어가 없다면?

은행 라이브러리를 작성하고 있다고 가정하자, 해당 라이브러리는 다른 은행이 뱅킹 소프트웨어를 작성할 수 있는 기반을 하는데 도움이 되는 라이브 러리이다.

```Swift
protocol Account {
  associatedtype Currency

  var balance: Currency { get }
  func deposit(amount: Currency)
  func withdraw(amount: Currency)
}
```
이 코드는 `Account`로 정의 된 것은 잔액을 확인하는 프로퍼티와, 입출금을 하는 메소드가 정의 되어 있다.

```Swift
typealias Wons = Int

class BasicAccount: Account {

  var balance: Wons = 0

  func deposit(amount: Wons) {
    balance += amount
  }

  func withdraw(amount: Wons) {
    if amount <= balance {
      balance -= amount
    } else {
      balance = 0
    }
  }
}
```
한국은행에서 이 프로토콜을 가져와 위와 같이 프로토콜을 준수해서 클래스를 만들었다고 친다.

`Account` 프로토콜에서 잔고는 읽기를 요구사항으로 정의 했지 쓰기 기능에 대해서 제한은 걸어두지 않았다.

```Swift
//계좌를 개설한다.
let account = BasicAccount()

//계좌에 입 출금한다.
account.deposit(amount: 10_000)
account.withdraw(amount: 5_000)

//돈을 1백만원으로 변경한다?
account.balance = 1_000_000
```
계좌의 잔고 변동은 입출금 메소드를 통해서만 변경이 가능해야 하는데 이 경우 아무런 제약사항이 없기 때문에 외부에서 내부 상태를 직접적으로 변경할 수 있다.

> 이러한 예시로 접근 제어가 보안 기능과 연관이 있다고 착각할 수 있다. 접근 제어의 목적은 보안이 아니라 객체의 불변성과 정확성을 유지하는 것에 있다는 것을 명심하자.


## 접근 제어 종류
접근 제어는 속성이나 메소드 앞에 형식 선언 앞에 modifier 키워드를 추가로 선언한다.

예를들어 위와 같은 `BasicAccount`에 접근제어를 설정하자면

```Swift
typealias Wons = Int

class BasicAccount: Account {

  private(set) var balance: Wons = 0

  func deposit(amount: Wons) {
    balance += amount
  }

  func withdraw(amount: Wons) {
    if amount <= balance {
      balance -= amount
    } else {
      balance = 0
    }
  }
}
```
balance를 설정하는 set은 `private`로 외부에서 이를 접근하는 것을 제한한다. 아까와 같은 실행 코드를 작성하게 되면 balance 메소드는 접근이 불가하다며 컴파일 에러를 발생시킨다.

- private : 동일한 소스 파일 내에서 타입 정의, 모든 내부 타입, 해당 타입의 확장자에만 액세스 할 수 있다.
- fileprivate : 정의된 소스 파일 내 어디에서나 액세스 할 수 있다.
- internal : 정의된 모듈 내 어디에서나 액세스 할 수 있다. 이 수준은 Swift에서 기본으로 설정되어 있다.
- public : 모듈을 가져오는 모든 곳에서 액세스 할 수 있다.
- open : public과 동일하며 모듈의 코드를 재정의 할 수 있는 추가 기능이 부여가 된다.


## Private
Private 접근 제어는 정의된 엔티티와 그 안에 있는 모든 Nested type에 대한 접근을 제한한다(이를 Lexical scope라고도 함). 동일한 소스 파일 내의 extension에 대한 엔티티에는 액세스 할 수 있다.

```Swift
class CheckingAccount: BasicAccount {
  private let accountNumber = UUID().uuidString

  class Check {
    let account: String
    var amount: Wons
    private(set) var cashed = false

    func cash() {
      cashed = true
    }

    init(amount: Wons, from account: CheckingAccount) {
      self.amount = amount
      self.account = account.accountNumber
    }
  }
}
```
`accountNumber`의 경우 고유한 id이므로 상수이면서 외부에서 접근을 제한하며 `Check` Nested 타입의 경우 여기까지 접근을 할 수 있다.

해당 예금 계좌는 수표를 쓸 수도 있고 이를 현금화 할수도 있어야 하기 때문에 아래 메소드를 추가한다.

```Swift
func writeCheck(amount: Wons) -> Check? {
  //출금을 하는데 출금 금액보다 잔고수가 많아야 한다.
  guard balance > amount else {
    return nil
  }

  //출금 목표 금액 만큼의 수표를 작성한다.
  let check = Check(amount: amount, from: self)
  //출금
  withdraw(amount: check.amount)
  return check
}

func deposit(_ check: Check) {
  //수표가 아직 현금화 되지 않았을 때만 진해앟ㄴ다.
  guard !check.cashed else {
    return
  }

  //계좌에 입금한다.
  deposit(amount: check.amount)
  //수표를 현금화 했다고 알린다.
  check.cash()
}
```

철수가 영희에게 수표를 쓴다고 가정하자
```Swift
//철수의 계좌를 만들고 3백만원을 입금한다.
let 철수Checking = CheckingAccount()
철수Checking.deposit(amount: 3_000_000)

//철수 계좌로부터 2백만원의 수표를 작성한다.
let check = 철수Checking.writeCheck(amount: 2_000_000)!

//영희의 계좌를 만들고 수표를 철수가 쓴 수표를 입금한다.
let 영희Checking = CheckingAccount()
영희Checking.deposit(check)
영희Checking.balance // 2_000_000

//이미 사용한 수표를 한번 더 사용하지만
//계좌는 변도잉 없다.
영희Checking.deposit(check)
영희Checking.balance // 2_000_000
```

코드 작성을 해보면 알겠지만 `영희Checking.`까지 입력했을 때 자동 완성이 표시하는 인터페이스를 제공한다.

또 철수가 작성한 수표의 경우 한번 사용하고 현금화가 되었는데 우리는 이를 private(set)으로 작성하였기 때문에 외부에서 직접적으로 현금화된 상태를 변경할 수 없다.

또 check의 경우 Basic Account의 Nested 유형인데 private로 선언된 `accountNumber`직접적으로 접근할 수 없지만 우리는 초기화때 이를 `account`로 넘겨 받았기 때문에 이를 통해 접근할 수 있다.


여기까지 작성된 코드 중
Account protocol과 Wons typealies BasicAccount를
플레이그라운드에서 Sources 폴더로 Account.swift 라는 파일을 만들고 옮겨보자 

그리고 CheckingAccount 클래스도 Sources 폴더에 
CheckingAccount.swift 파일을 만들고 옮기자

이렇게 되면 남은 철수가 영희에게 수표를 작성하고 옮기는 코드가 CheckingAccount를 찾지 못해 컴파일 에러가 발생한다. 이는 나중에 해결할 것이다.

## Fileprivate
fileprivate는 private가 제공하는 동일한 파일 내에서 동일한 lexical scope와 확장자 대신 엔티티와 동일한 파일에 작성된 모든 코드에 대한 접근을 허용한다.

지금 당장은 아까 작성한 `Check`에 대해 코더가 접근하고 수정하는 것을 막을 방법이 없다.

우리는 코드의 안전성을 위해서 `CheckingAccount`에서만 Check가 작성되기를 원한다.

Check의 생성자를 private로 선언해버리면 어떻게 될까?

```Swift
private init(amount: Wons, from account: CheckingAccount) { //...
```
외부에서 Check를 선언하는 것을 막을 수 있지만 CheckingAccount에서 접근하는 것도 막아버리니 원하는 것은 아니다.

이런 상황에 사용할 수 있는 것이 바로 fileprivate이다. Check의 생성자를 fileprivate로 바꾸어 보자.

이렇게 되면 오로지 CheckingAccount에서만 Check를 작성할 수 있다.

## Internal, Public, Open
private와 fileprivate는 다른 타입의 파일에 접근하는 코드를 보호할 수 있다. 이러한 Access Modifier는 Internal 디폴트 액세스 레벨에서 엑세스룰 수정했다.

`Internal` 엑세스 레벨은 엔터티가 정의된 소프트웨어 모듈 내의 모든 위치에서 엔터티에 액세스 할 수 있음을 의미한다. 지금까지 모든 코드를 하나의 플레이그라운드 파일을 작성했는데 이는 모두 동일한 모듈에 있음을 의미한다


내부 액세스 수준은 엔터티가 정의된 소프트웨어 모듈 내의 모든 위치에서 엔터티에 액세스할 수 있음을 의미합니다. 지금까지 모든 코드를 하나의 플레이그라운드 파일에 작성했습니다. 이는 모두 동일한 모듈에 있음을 의미합니다.

플레이그라운드의 Sources 디렉토리에 코드를 추가하면 플레이그라운드에서 사용하는 모듈을 효과적으로 생성한 것이다. Xcode에서 플레이그라운드가 작동하는 방식으로 Sources 디렉토리의 모든 파일은 한 모듈의 일부이며 플레이그라운듸 모든 것은 Sources 폴더의 모듈을 사용하는 또 다른 모듈이다.

### Internal
플레이그라운드로 돌아가서 아까, private가 끝나고 Sources폴더로 파일을 나눈 뒤 코드가 작동하지 않는 것을 알고 있다.

CheckingAccount를 찾을 수 없다는 이유로 컴파일 에러가 발생하고 있다.

이에대해서 더 잘 설명하려면 `Public`과 `Open`에 대해서도 알아야 한다.

>Internal은 별도로 사용하지 않았지만 이는 Swift에서 기본 액세스 수준이므로 명시적으로 선언할 필요가 없다.

### Public
`CheckingAccount`를 플레이그라운드에 정상적으로 표시되게 하려면 액세스 수준을 Internal에서 Public으로 변경해야 한다.
Public은 정의된 모듈 외부의 코드에서 보고 접근할 수 있는 엔터티이다.

CheckingAccount 클래스에 Public modifier를 추가하자
또한 CheckingAccountrk Account 모듈에서 BasicAccount를 불러올 수 있도록 BasicAccount에도 public을 추가하자

이번엔 CheckingAccount에 대한 접근은 가능하지만 여전히 다음과 같은 에러가 발생한다.

*CheckingAccount' initializer is inaccessible due to 'internal' protection level*

CheckingAccount의 생성자가 internal 보호 수준으로 접근할수가 없다고 한다.

타입 자체는 Public으로 공개되었지만 해당 멤버는 여전히 Internal이므로 모듈 외부에서 사용할 수가 없다. 이제 덕지 덕지 public을 붙일 차례이다.

BasicAccount와 CheckingAccount에 기본 생성자를 public으로 해서 새로 만들어 주고

BasicAccount의 경우 balance, deposit, siwthdraw 그리고 typealias를 모두 public으로 선언한다.

CheckingAccount에서는 writeCheck(amount:), deposit(_:) Check을 모두 public으로 선언한다.

BasicAccount에서 balance는 private(set)으로 선언 되어 있는데 이경우는

```Swift
public private(set) var balance: Wons = 0
```
위와 같이 작성해 주면 된다.

### Open
이제 CheckingAccount 및 해당 멤버들이 공개되어 뱅킹 인터페이스를 설계된 대로 사용할 수 있다. 하지만 한가지
기존 계좌 형태가 아니라 다른 특별한 형태, 예를들어 이자가 붙는 계좌를 만든다고 했을 때를 보자

```Swift
class SavingsAccount: BasicAccount {
  var interestRate: Double

  init(interestRate: Double) {
    self.interestRate = interestRate
  }

  func processInterest() {
    let interest = Double(balance) * interestRate
    deposit(amount: Int(interest))
  }
}
```
그러나 BasicAccount가 Open이 아니라서 재정의 할 수가 없다는 에러가 발생한다. 이제 BasicAccount를 Public에서 Open으로 수정해서 해결 할 수 있다.

BasicAccount 가 open으로 공개되었다고 해서 그 안에 정의된 출금, 입금 메소드를 재정의 할 수는 없다.

```Swift
override func deposit(amount: Wons) {

    super.deposit(amount: 1_000_000)
}
```
다행이도 이런 코드는 동작하지 않는다.

## Extension 코드 조직화
접근 제어의 주제는 코드가 느슨하게 결합되고 응집력이 높아야 한다는 내용이다. 
느슨하게 결합된 코드는 한 엔터티가 다른 엔터티에 대해 아는 정도를 제한하므로 코드의 다른 부분이 또 다른 부분에 덜 의존하게 된다. 앞에서 나온 내용처럼 응집력이 높은 코드는 밀접하게 관련된 코드가 함게 작업하여 작업을 수행하는데 도움이 된다.

### 행동(Behavior)에 의한 Extension
Swift의 효과적인 전략은 코드를 행동에 따라 extension을 구성하는 것이다. extension 자체에도 접근 제어를 적용할 수 있다. 그러면 전체적인 코드 섹션을 public, internal, private로 분류하는데 도움이 된다.

예를들어 CheckingAccount에서 사기 방지 기능을 추가하려고 한다.

CheckingAccount에 다음과 같은 속성을 추가한다.
```Swift
private var issuedChecks: [Int] = []
private var currentCheck = 1
```

그리고 private extension을 추가한다.

```Swift
private extension CheckingAccount {
  func inspectForFraud(with checkNumber: Int) -> Bool {
    issuedChecks.contains(checkNumber)
  }

  func nextNumber() -> Int {
    let next = currentCheck
    currentCheck += 1
    return next
  }
}
```
위 메소드와 프로퍼티로 수표 발행의 사기 행각을 추적을 계획이다.
이 확장자는 private로 선언했는데 암시적으로 해당 멤버 전부를 private로 보게 된다. 이렇게 하면 해당 기능은 오로지 CheckingAccount에서만 컨트롤 할 수 있다.

### 프로토콜에 따른 Extension
또 다른 분류법은 프로토콜 준수를 기반으로 확장하는 것이다.
```Swift
extension CheckingAccount: CustomStringConvertible {
  public var description: String {
    "Checking Balance: $\(balance)"
  }
}
```
위 확장은 CustomStringConvertible을 구현하는데 더 중요한 것은 다음과 같다.

- description이 CustomStringConvertible의 일부분임을 분명히 한다.
- 다른 프로토콜을 준수하는데 영향을 주지 않는다.
- CheckingAccount의 나머지 에 대해 영향을 끼치지 않고 손쉽게 제거하고 추가할 수 있다. 이해하기도 쉽다

### available()

SavingsAccount를 보면 이자를 증가시키는 메소드를 여러번 호출해서 반복적으로 동작해서 이자 추가를 남용할 수도 있다. 이 기능을 좀더 안전하게 만들기 위해 계정에 PIN을 추가할 수 있다.
```Swift
class SavingsAccount: BasicAccount {
  var interestRate: Double
  private let pin: Int
  
  init(interestRate: Double, pin: Int) {
    self.interestRate = interestRate
    self.pin = pin
  }
  
  func processInterest(pin: Int) {
    if pin == self.pin {
      let interest = balance * interestRate
      deposit(amount: interest)
    }
  }
}
```
SavingsAccount에 pin을 추가하고 이자 증가 메소드가 이 PIN을 매개변수로 사용하는지 확인한다.

이제 이자 증가 메소드를 함부로 사용할 수 없도록 했지만 기존에 이 SavingAccount클래스를 사용하던 은행 클라이언트는 업데이트된 코드로 인해서 기존에 쓰던 코드가 컴파일이 되지 않는다.

이전 구현을 사용하는 코드가 깨지는 것을 방지하려면 코드를 교체하는 대신 더 이상 사용하지 않아야 한다.

```Swift
class SavingsAccount: BasicAccount {
  var interestRate: Double
  private let pin: Int
  
  @available(*, deprecated, message: "Use init(interestRate:pin:) instead")
  init(interestRate: Double) {
    self.interestRate = interestRate
    pin = 0;
  }
  
  init(interestRate: Double, pin: Int) {
    self.interestRate = interestRate
    self.pin = pin
  }
  
  @available(*, deprecated, message: "Use processInterest(pin:) instead")
  func processInterest() {
    let interest = balance * interestRate
    deposit(amount: interest)
  }
  
  func processInterest(pin: Int) {
    if pin == self.pin {
      let interest = balance * interestRate
      deposit(amount: interest)
    }
  }
}
```
이렇게 하면 이전버전을 사용하려고 하는 유저에게 경고 메시지를 남겨줄 수 있다.

별표 매개변수는 영향을 받는 플랫폼을 나타내고, 두번째 매개변수는 deprecated, renamed, unavailable을 나타낸다.

### Opaque return types
은행 라이브러리 사용자를 위한 공개 API를 만들어야 된다고 하자
`createAccount`라는 새 계정을 만드는 함수를 만들어야 한다.
이 API의 요구 사항 중 하나는 구현 세부 정보를 숨겨 클라이언트가 일반 코드를 작성하도록 권장하는 것이다.
이는 생성 중인 계정 유형(BasicAccount, CheckingAccoung 또는 SavingsAccount)를 노출해서는 안된다는 의미이다.
대신 프로토콜 Account를 준수하는 일부 인스턴스만 반환한다.

이를 활성화하려면 우선 Accouns 프로토콜을 public으로 두어야 한다. 

```Swift
func createAccount() -> Account {
  CheckingAccount()
}
```
위와 같이 이제 코드를 작성하면 에러가 발생하는데
프로토콜 Account는 Self 또는 연관 타입 요구사항이 있기 때문에 일반 제약 조건으로만 사용할 수 있다고 한다.

이 문제를 해결하기 위해서는 아래 처럼 쓰면 된다.
```Swift
func createAccount() -> some Account {
  CheckingAccount()
}
```
some 키워드를 붙였다. 이게 불투명한 반환 타입이며 Account 클래스 타입을 노출하지 않고 함수가 반환하려는 타입을 결정할 수 있도록 한다.

더 자세한 내용은 고급 프로토콜과 제네릭으로...