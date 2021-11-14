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