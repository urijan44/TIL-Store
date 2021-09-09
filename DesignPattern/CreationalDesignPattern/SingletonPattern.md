# Signleton Pattern

>Reference by raywenderlich Design Patterns

싱글톤 패턴은 Creational Design Pattern의 하나로 클래스의 하나의 인스턴스로만 제한 하는 것을 말한다.

해당 클래스에 대한 모든 참조는 동일한 인스턴스를 참조하고 iOS 앱 개발에 매우 읾반적으로 사용되는 디자인 패턴이다.

싱글톤 플러스 패턴도 있는데 이는 다른 인스턴스도 생성 할 수 있는 공유 싱글톤 인스턴스를 제공한다.

## 언제 사용하나?
싱글톤 패턴은 클래스를 하나의 인스턴스로 밖에 쓰지 못하기 때문에 역으로 말해서 단 하나의 클래스를 단 하나의 인스턴스로 참조해야 하는 경우에 사용한다. 예를 들어서 앱의 설정이나 저장소와 같은 전체 앱에서 단 하나의 인스턴스만 존재 하는 경우를 싱글톤 패턴을 구현해서 사용할 수 있다.

```Swift
import UIKit

// MARK: - Singleton
let app = UIApplication.shared
// let app2 = UIApplication()
```
UIApplication이 대표적인 iOS 앱 개발에 사용되는 싱글톤이다. app2를 주석 해제 처리하면 컴파일러 오류가 발생한다.

싱글톤 클래스를 만드는 법은 어렵지 않다.

```swift 
public class MySignletonClass {
  static let shared = MySingleton()
  private init() {}
}

let mysingletonClass = MySingletonClass.shared
```

shared라는 상수로 static으로 선언하고 추가 인스턴스를 방지하기 위해 생성자를 private로 만든다.
이제 이 클래스는 다른 인스턴스를 생성할 수 없게된다.

`FileManager`의 경우 대표적인 싱글톤 플러스 이다. 싱글톤 플러스를 만드는 법도 크게 다르지 않다.

```Swift
public class MySingletonPlusClass {
  static let shared = MySingletonPlus()
  public init() {}
}
let singletonPlus1 = MySingletonPlusClass.shared
let singletonPlus2 = MySingletonPlusClass()
```

## 주의점
싱글톤 패턴은 인스턴스 내부의 객체를 공유하기 때문에 편하게 사용할 수 있기 때문에 남용 하는 경우가 있는데 이는 전체적인 어플리케이션의 흐름을 제어하기에 방해가 될 수 있으므로 가능한 남발하지 않는 것이 좋다.

흔히 뷰 컨트롤러에서 다른 뷰 컨트롤러로 정보를 전달할 때 싱글톤 패턴 할 수 있는데 가능한 경우는 이니셜라이저와 속성을 통해 전달하는 것이 좋다.