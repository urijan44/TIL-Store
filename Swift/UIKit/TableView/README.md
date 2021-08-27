# Table View

## Index
- [일부 섹션만 선택기능 활성화 하기](#일부-섹션만-선택기능-활성화-하기)

## 일부 섹션만 선택기능 활성화 하기
TableView에서 일부 섹션만 선택해서 동작을 활성화 하고 일부는 선택이 되지 않는 셀로 설정할 수 있다.

`tableView(_:willSelectRowAt:)`로 그게 가능한데

```Swift
override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
  if indexPath.section == 0 || indexPath.section == 1 {
    return indexPath
  } else {
    return nil
  }
}
```
섹션 인덱스가 0과 1인 경우는 선택이 가능하고 그외의 경우는 nil을 리턴한다. 이렇게 되면 나머지 인덱스는 선택 기능이 비활성화 된다.

## 화면의 다른 영역을 선택 하면 키보드 사라지게 하기
```Swift
ovveride func viewDidLoad() {
  let gestureRecognizer = UITapGestureRecognizer(
  target: self, 
  action: #selector(hideKeyboard))
  gestureRecognizer.cancelsTouchesInView = false
  tableView.addGestureRecognizer(gestureRecognizer)
}

@objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
  let point = gestureRecognizer.location(in: tableView)
  let indexPath = tableView.indexPathForRow(at: point)

  if indexPath != nil && indexPath!.section == 0 && 
  indexPath!.row == 0 {
    return
  }
  descriptionTextView.resignFirstResponder()
}
```