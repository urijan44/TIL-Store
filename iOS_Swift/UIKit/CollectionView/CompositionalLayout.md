# CompositionalLayout

- CompositionalLayout도 마찬가지로 ios 13.0 도입으로 기존 flow-layout 으로 (할 수는 있었겠지?)는 하기 어려웠던 복잡한 레이아웃을 좀더 편하게 할 수 있는 것으로 보인다.

# Item, Group, Section
- 기존 FlowLayout이 Section-Item 으로 구분되어 있었다면 CompositionalLayout는 Item, Group, Section으로 구분된다.
- Section이 Group을 가지고 Group이 Item들을 가지는 개념으로 이론만 봤을 때는 굉장히 쉬울 것 같았는데 막상 적용해 보니 헷갈려서 글을 정리하게 되었다.

```Swift
func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
      
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(0.3))
      let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .groupPaging
      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      section.interGroupSpacing = 10
      
      return section
    }
    return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
  }
```
- 위와 같은 구조로 collectionView의 CollectionViewLayout 프로퍼티로 전달하면 된다.
- 여기서 Section의 개념은 지금 보이는 화면의 View로 생각하면 될 것 같다. 왜냐하면 group의 높이가 0.3 즉 30% 차지를 하는데 지금 DataSource에 넣어 둔 경우 3개의 DataSource Section을 가지고 있다. 결과적으로 CompositionalLayout 1섹션에 30프로 높이로 그룹 3개가 표시가 된다. 위 아래 스크롤 엎이 한페이지에 3개의 그룹(DataSource Section)이 모두 들어가게 된다.
- group의 Width같은 경우도 0.6인데, 지금 아이템이 그룹의 1:1 비율을 차지하고 있으므로, 아이템의 화면 너비의 0.6 만큼 차지하고 다음 아이템이 패딩값을 계산하고 0.4(대충) 만큼 미리 보이게 되는 형태이다. 
- 즉 group이 화면에서 차지하는 크기를 결정하게 되고, 아이템은 그 그룹 안에서 차지하는 비율로 볼 수 있겠다.
- group을 설정할 때 `NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])`의 경우 vertical 메소드로 접근했는데 이 경우 만약 아이템의 높이를 0.3으로 설정하게 되면 아이템이 먼저 버티컬로 3개가 들어가고, 그다음 수평 스크롤로 이동후 그 다음 아이템이 표시가 된다.
- 만약 vertical 이 아닌 `horizontal`을 하게 되면 아이템의 높이를 0.3으로 설정하게 되더라도 그룹 높이의 0.3만큼만 차치하는 1개의 아이템만 그룹에 표시가 된다. 나머지는 다 수평 스크롤로 펼쳐지게 된다.

```Swift
section.orthogonalScrollingBehavior = .groupPaging
```
- section의 위 옵션의 경우 스크롤의 기능을 설정할 수 있다.
[개발자문서](https://developer.apple.com/documentation/uikit/uicollectionlayoutsectionorthogonalscrollingbehavior)
- none: 특별한 기능이 없다.
- continuous: 스크롤을 놓아도(스크롤 스텁 제스처), 스크롤이 바로 멈추지 않고 가속도를 가지고 진행되다가 멈춘다
- continuousGroupLeadingBoundary: 스크롤을 멈추면, 아무곳에나 멈추지 않고 그룹의 경계선에 딱 맞춰서 멈춘다(이거좋다)
- paging: 말그대로 페이징 처럼 딱 맞춰서 멈춰준다. 섹션 기준이라 그룹의 사이즈를 고려하지 않고 쓰면 이상하다
- groupPaging: 그룹 기준으로 페이징을 해준다. 그룹 경계에 맞게 딱딱 멈춰준다.
- groupPagingCentered: 그룹 페이징 이 뷰의 가운데에서 딱 맞춰 멈춰준다. 텍스트 뷰 정렬에서 가운데 정렬로 볼 수 있겠다.

## Header(Footer)
- 테이블뷰나 FlowLayout에서 했던 것처럼 헤더에 대한 클래스를 생성 후 추가할 수 있다. 방식은 똑같은데 방법은 다르다고 해야하나?
- 우선 콜렉션 뷰의 헤더(푸터)는 `UICollectionReusableView` 클래스로 정의한다. 우선 간단한 Label을 출력하는 클래스
```Swift
//Raywenderlich
import UIKit

final class TitleSupplementaryView: UICollectionReusableView {
  static let reuseIdentifier = String(describing: TitleSupplementaryView.self)
  
  let textLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is not implemented")
  }
  
  private func configure() {
    addSubview(textLabel)
    textLabel.font = .preferredFont(forTextStyle: .title2)
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let inset: CGFloat = 10
    
    NSLayoutConstraint.activate([
      textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
      textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
      textLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
      textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
    ])
  }
}
```

- 이렇게 작성 된 헤더 클래스는 CompositionalLayout Configure에 추가해주면 된다.

# SupplementaryView
- 넷플릭스 앱 같은 걸 보면 컬렉션 뷰 아이템에 순위 숫자가 겹쳐서 보인다. 아이템에 다른 아이템을 겹쳐서 보이게 하는 방법인데 이 또한 `SupplementaryItem`으로 구현이 가능하다.

- 우선 kind를 설정
```Swift
static let badgeElememtKind = "badge-element-kind"
```

- 미리 만들어둔 View를 collectionView에 등록하고
```Swift
collectionView.register(BadgeSupplementaryView.self, forSupplementaryViewOfKind: QueuedTutorialController.badgeElememtKind, withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier)
```
- 참고로 SupplementaryItem의 경우 `UICollectionReusableView`를 상속해서 만든다.

- 컬랙션 뷰 layout 정의하는 곳에서 다음과 같이 작성해볼 수 있다.
```Swift
 func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let anchorEdges: NSDirectionalRectEdge = [.top, .trailing]
    let offset = CGPoint(x: 0.3, y: -0.3)
    let badgeAnchor = NSCollectionLayoutAnchor(edges: anchorEdges, fractionalOffset: offset)
    
    let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20), heightDimension: .absolute(20))
    let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize, elementKind: QueuedTutorialController.badgeElememtKind, containerAnchor: badgeAnchor)

    ...
    ...
    let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
```

- 앵커는 아이템에 어디 위치에 시킬 것인지 결정하는데 `NSCollectionLayoutAnchor`를 통해서 만들 수 있다. `NSCollectionLayoutAnchor`가 정의된 문설르 보면
```Swift

    //                       +------------------+  +------+   +------------------+
    //                       | [.top, .leading] |  |[.top]|   | [.top,.trailing] |
    //                       +--+---------------+  +---+--+   +---------------+--+
    //                          |                      |                      |
    //                          v                      v                      v
    //                       +-----+----------------+-----+----------------+-----+
    //                       |~~~~~|                |~~~~~|                |~~~~~|
    //                       |~~~~~|                |~~~~~|                |~~~~~|
    //                       +-----+                +-----+                +-----+
    //                       |                                                   |
    //                       +-----+                                       +-----+
    //   +--------------+    |~~~~~|                                       |~~~~~|    +-------------+
    //   |  [.leading]  |--->|~~~~~|                                       |~~~~~|<---| [.trailing] |
    //   +--------------+    +-----+                                       +-----+    +-------------+
    //                       |                                                   |
    //                       +-----+                +-----+                +-----+
    //                       |~~~~~|                |~~~~~|                |~~~~~|
    //                       |~~~~~|                |~~~~~|                |~~~~~|
    //                       +-----+----------------+-----+----------------+-----+
    //                          ^                      ^                      ^
    //                          |                      |                      |
    //                      +---+---------------+ +----+----+  +--------------+----+
    //                      |[.bottom, .leading]| |[.bottom]|  |[.bottom,.trailing]|
    //                      +-------------------+ +---------+  +-------------------+
    //
    // Edges are specified as shown above.
  ```
  - 친절하게 위치를 만들어 놓았다.
  - 위 방법을 통해 앵커를 만들고 난뒤, 헤더와 다르게 `NSCollectionLayoutBoundarySupplementaryItem`이 아닌 `NSCollectionLayoutSupplementaryItem`로 인스턴스를 생성해서 만든다.

  - dataSource도 생성해야 한다.
  ```Swift
  dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
      
      guard let self = self,
            let tutorial = self.dataSource.itemIdentifier(for: indexPath),
            let badge = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier, for: indexPath) as? BadgeSupplementaryView else { return nil }
      
      if tutorial.updateCount > 0 {
        badge.isHidden = false
      } else {
        badge.isHidden = true
      }
      
      return badge
    }
  ```
  - DataSource는 마찬가지로 supplementaryViewProvider로 생성할 수 있다.