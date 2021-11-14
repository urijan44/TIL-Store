# FlowLayout

- FlowLayout은 콜렉션 뷰의 레이아웃을 결정하는 iOS13.0 이전의 방법으로 델리게이트 방식으로 구현되어 있다.

```Swift
class ViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  let dataSource = DataSource()
  let delegate = EmojiCollectionViewDelegate(numberOfItemsPerRow: 6, interItemSpacing: 8)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.dataSource = dataSource
    collectionView.delegate = delegate
  }
}

class EmojiCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
  let numberOfItemsPerRow: CGFloat
  let interItemSpacing: CGFloat
  
  init(numberOfItemsPerRow: CGFloat, interItemSpacing: CGFloat) {
    self.numberOfItemsPerRow = numberOfItemsPerRow
    self.interItemSpacing = interItemSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let maxWidth = UIScreen.main.bounds.width
    let totalSpacing = interItemSpacing * numberOfItemsPerRow
    
    let itemWidth = (maxWidth - totalSpacing) / numberOfItemsPerRow
    return CGSize(width: itemWidth, height: itemWidth)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return interItemSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if section == 0 {
      return UIEdgeInsets(top: 0, left: 0, bottom: interItemSpacing / 2, right: 0)
    } else {
      return UIEdgeInsets(top: interItemSpacing / 2, left: 0, bottom: interItemSpacing / 2, right: 0)
    }
  }
}
```
- 참고로 `UICollectionViewDelegateFlowLayout`은 `UICollectionViewDelegate`를 채용한다. 따라서 FlowLayout 델리게이트를 채용했다면 UICollectionViewDelegate 메서드 들고 바로 사용할 수 있다.

- View Controller에서는 CollectionView Delegate에 할당할 수 있다.

# DataSource
- DataSource 또한 델리게이트 패턴으로 구현되어있다.
```Swift
class DataSource: NSObject, UICollectionViewDataSource {
  let emoji = Emoji.shared
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    emoji.sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let category = emoji.sections[section]
    let emoji = self.emoji.data[category]
    
    return emoji?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else {
      fatalError("Cell cannot be created")
    }
    
    let category = emoji.sections[indexPath.section]
    let emoji = self.emoji.data[category]?[indexPath.item] ?? ""
    
    emojiCell.emojiLabel.text = emoji
    
    return emojiCell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmojiHeaderView.reuseIdentifier, for: indexPath)
            as? EmojiHeaderView else { fatalError("Cannot create EmojiHeaderView")}
    
    let category = emoji.sections[indexPath.section]
    header.textLabel.text = category.rawValue
    
    return header
  }
}

extension DataSource {
  func addEmoji(_ emoji: String, to category: Emoji.Category) {
    self.emoji.data[category]?.append(emoji)
  }
}
```
- TableView와 비슷하게 section의 수, 섹션 안 아이템의수, 셀 정의로 이우러져 있다. 헤더 푸터 같은 경우는 `viewForSupplementaryElementOfKind`로 나타낼 수 있다.

## Add Data

```Swift
  @IBAction func addEmoji(_ sender: UIBarButtonItem) {
    let (category, randomEmoji) = Emoji.randomEmoji()
    dataSource.addEmoji(randomEmoji, to: category)
    
    let emojiCount = collectionView.numberOfItems(inSection: 0)
    let insertedIndex = IndexPath(item: emojiCount, section: 0)
    collectionView.insertItems(at: [insertedIndex])
  }
```
- 데이터를 추가할 때 데이터 모델에 추가 후 `reloadData()`를 해도 되지만 reloadData는 전체 데이터를 리로드 하는 만큼 비용도 크고, 애니메이션이 없어 딱딱하다.
- insertItems을 이용하여 비교적 효율적으로 데이터를 추가할 수 있다.
- 이때 순서를 중요시 해야 하는데 꼭 DataSource를 먼저 업데이트 한 후에 UI를 업데이트 해야 한다.
- 위 같은 경우 model에 데이터를 먼저 추가 한 뒤에 insertItems를 사용해야 한다.

## isEditing

- 뷰 컨트롤러가 네비게이션이 임베드 된 뷰 컨트롤러라면 navigationItem 요소 추가시

```Swift
navigationItem.leftBarButtonItem = editButtonItem
```
이렇게만 작성해도 간단하게 자동으로 토글이 되는 editButtonItem을 작성할 수 있는데 (처음에는 UITableViewController 로 클래스를 작성한 경우에만 사용 가능한 줄 알았다.)

해당 네비게이션 바 버튼의 이벤트는 ViewController의 setEditing 메서드를 오버라이딩 해서 사용할 수 있다.

```Swift
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    
    collectionView.indexPathsForVisibleItems.forEach {
      guard let cell = collectionView.cellForItem(at: $0) as? EmojiCell else { return }
      cell.isEditing = editing
    }
    
    if !isEditing {
      collectionView.indexPathsForSelectedItems?.compactMap{$0}.forEach { indexPath in
        collectionView.deselectItem(at: indexPath, animated: true)
      }
    }
  }
```
- `indexPathsForVisiableItems`는 표시 된 모든 셀의 인덱스 패스를 반환하는데 이를 통해 모든 셀의 속성에 접근할 수 있다. 이 경우 cell에 미리 정의해둔 isEditing을 접근한다.
- `indexPathsForSelectedItems`는 마찬가지로 선택된 아이템을 순회할 수 있다.

```Swift
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if isEditing && identifier == "showEmojiDetail" {
      return false
    }
    return true
  }
```
- 현재 셀 자체에 세그 를 연결 해 두어서 셀을 선택하면 자동으로 디테일 뷰로 넘어가도록 작성되어 있는데, 이를 비활성화 하고 아이템 셀렉트시 다른 이벤트를 추가할 수 있는 방법이다., `isEditing` (이것도 마찬가지로 ViewController 프로퍼티로 editButtonItem과 연동된다.!) 에디팅 모드 상태일 때 해당 세그 동작을 비활성화 할 수 있다.

```Swift
class EmojiCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: EmojiCell.self)
    
  @IBOutlet weak var emojiLabel: UILabel!
  
  var isEditing: Bool = false
  
  override var isSelected: Bool {
    didSet {
      if isEditing {
        contentView.backgroundColor = isSelected ? .systemRed.withAlphaComponent(0.5) : .systemGroupedBackground
      } else {
        contentView.backgroundColor = .systemGroupedBackground
      }
    }
  }
}
```
- 셀에 작성된 내용, isEditing 속성을 가지고 있다.
- isSelected 기본 속성을 이용해 선택된 경우, 그리고 에디팅 모드 인 경우 앞서 작성한대로 세그가 동작하지 않고, 셀 배경을 붉은색으로 바꿀 수 있다.

- collectionView는 `allowsMultipleSection`을 선택하면 다중 셀, 섹션을 선택할 수 있게 된다.

```Swift
  @IBAction func deleteEmoji(_ sender: UIBarButtonItem) {
    guard isEditing, let selectedIndices = collectionView.indexPathsForSelectedItems else { return }
//    let sectionsToDelete = Set(selectedIndices.map{$0.section})
//
//    sectionsToDelete.forEach { section in
//      let indexPathsForSection = selectedIndices.filter { $0.section == section }
//      let sortedIndexPaths = indexPathsForSection.sorted { lhs, rhs in
//        lhs.item > rhs.item
//      }
//      dataSource.deleteEmoji(at: sortedIndexPaths)
//      collectionView.deleteItems(at: sortedIndexPaths)
//    }
    
    
    let sortedIndexPaths = selectedIndices.sorted { lhs, rhs in
      lhs.item > rhs.item
    }
    dataSource.deleteEmoji(at: sortedIndexPaths)
    collectionView.deleteItems(at: sortedIndexPaths)
  }
```
- 마찬가지로 collectionView의 `indexPathsForSelectedItems`를 통해 삭제할 셀을 다수 선택해볼 수 있는데 단일 셀 삭제의 경우 상관없지만 다수의 아이템을 동시 삭제시에는 다음과 같은 상황을 고려해야 한다.

```
[1, 2, 3, 4, 5, 6]
```
- 위와 같은 배열이 있다고 가정했을 때 2, 4, 6을 각각 선택해서 삭제하는 상황이 되었다고 보자
- 마찬가지로 각각 인덱스 1, 3, 5로 indexPath를 전달하는데
- 2를 삭제하게 되는 순간 4와 6은 인덱스가 각각 3, 5에서 2, 4로 이동해 버린다 이렇게 되면 엉뚱한 셀이 삭제되거나 out of bound index 에러가 발생할 수 있다.
- 이를 방지하기 위해 삭제하고자 하는 셀 인덱스를 역으로 정렬하는 방법이 있다.
- 삭제 순서를 1, 3, 5가 아니라 5, 3, 1이 되 버리면
- 인덱스 패스가 엉킬 걱정을 하지 않아도 된다.
- 주석 처리된 코드도 동일하게 작성하지만 섹셜별로 나누어서 (굳이 구분해서) 삭제할 것인지 섹션 상관없이 삭제할 것인지 결정할 수 있다.

- DataSource에서는 다음과 같은 메소드를 추가해서 삭제 기능을 구현해 볼 수 있겠다.
```Swift
  func deleteEmoji(at indexPath: IndexPath) {
    let category = emoji.sections[indexPath.section]
    self.emoji.data[category]?.remove(at: indexPath.item)
  }
  
  func deleteEmoji(at indexPaths: [IndexPath]) {
    for path in indexPaths {
      deleteEmoji(at: path)
    }
  }
```

