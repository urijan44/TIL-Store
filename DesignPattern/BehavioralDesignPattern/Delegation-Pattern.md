# Delegation Pettern
Delegation은 대리자 패턴, 위임 패턴 으로 번역할 수 있다.

UIkit에서 Delegate 패턴은 거의 필수적인 요소이므로 UIkit을 다루어 봤다면 적어도 사용법은 숙지하고 있으리라.

구체적으로 Delegation Pettern에 대해서 알아보자

Delegation Pettern은 객체가 다른 도우미 객체를 사용해 데이터를 제공하거나 작업 자체를 수행하는 것을 가능하게 한다.
이 패턴은 3가지 파트로 구분된다.

- `Object Needing a Delegate` : Delegating object라고도 하는 이것은 Delegate(대리자)를 가지고 있는 객체
- `Delegate Protocol` : 대리자가 구현하거나 구현해야 하는 메소드를 정의한다.
-  `Object Acting as a Delegate` : 대리자 프로토콜을 구현하는 도우미 객체인 대리자

구체적인 객체 대신 Delegate protocol에 의존하는 것이 구현함에 있어 훨씬 더 유연하게 사용할 수 있다

## 언제 사용할까?
본 패턴은 덩치가 큰 클래스를 분할하여 재사용 가능한 구성 요소를 만들 때 필요하다. 대표적으로 UIKit의 DataSource와 Delegate 로 사용하는 것들이 실제로 Delegation Pettern을 사용하는 것들이다.

```Swift
import UIKit

public class MenuViewController: UIViewController {
  @IBOutlet public var tableView: UITableView! {
    didSet {
      tableView.dataSource = self
      tableView.delegate = self
    }
  }
  
  private let items = ["Item 1", "Item 2", "Item 3"]
}

extension MenuViewController: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}

extension MenuViewController: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    items.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = items[indexPath.row]
    return cell
  }
}
```
흔히 알고있는 UIKit에서 Delegation Pattern을 사용하는 코드이다.
MenuViewController는 프로퍼티로 UITableView를 가지고 있고 TableView에 동작하는 데이터나 기능들을 MenuViewController에서 수행하기 위해 tableView에 정의된 Delegate 기능을 정의한다.

`MenuViewController`는 TableView에서 셀이 선택되었을 때, 데이터가 어떻게 내부에서 전달되고 셀을 어떻게 구성되는지 자세히 알 필요 없다. tableView가 제공해주는 Delegate에 따라 정의만 해주면 나머지 처리는 TableView에서 알아서 한다. 만약 이를 대리자 패턴을 사용하지 않았다면
셀 데이터를 처리하고 셀을 구성하는 코드까지 MenuViewController에 노출되어 코드가 복잡해 졌을 것이다.

`TableView` 입장에서도 셀을 선택하고, 셀을 표시하는 방법까지 정의해줄 필요는 없다. 그것까지 전부 자신 내부에 정의하기에는 너무 케이스가 많고 자체적으로도 복잡해진다. 셀을 선택하고 표시하는 기능은 내가 할테니 구체적으로 어떻게 사용할 것인지는 Delegate를 통해 맡겨 버린다. 말그대로 위임이다.

이번에는 MenuViewController가 본인이 가지고 있는 items 프로퍼티가 선택 되었을 때 동작은 외부에 맡기려고 한다. 이 경우 MewViewController는 item을 선택했을 때 테이블 뷰 셀 선택으로 연결하는데 이 방법은 외부에 알릴 필요 없다. 선택해서 어떻게 쓸 것인지 구체적인 방법 기술은 외부에 맡기는 것이다.

```Swift
import UIKit

public protocol MenuViewControllerDelegate: AnyObject {
  func menuViewController(_ menuViewController: MenuViewController, didSelectItemAtIndex index: Int)
}

public class MenuViewController: UIViewController {
  
  public weak var delegate: MenuViewControllerDelegate?
  @IBOutlet public var tableView: UITableView! {
    didSet {
      tableView.dataSource = self
      tableView.delegate = self
    }
  }
  //...
}
```