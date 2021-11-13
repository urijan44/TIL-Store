# CollectionView

- 컬랙션 뷰는 테이블 뷰와 같이 많은 데이터를 입맛에 맞게 자동으로 보여줄 수 있는 뷰로, 테이블 뷰가 수직 스크롤만 가능하다면 컬렉션 뷰는 수직, 수평 스크롤이 모두 가능하다. 가장 컬렉션 뷰가 돋보이는 대표적인 예가 앱스토어 어플리케이션이다.
- 컬렉션 뷰의 레이아웃은 크게 3가지로 구분된다.
    - Items: 컬렉션 뷰의 가장 작은 데이터 조각이다. 사진, 버튼, 등등의 뷰 등 우리가 보여주고자 하는 뷰가 된다.
    - Groups: 이러한 아이템들은 그룹안에 싸여있다. 그룹은 스크롤의 방향을 결정하거나 복잡한 레이아웃을 설정할 수 있다.
    - Sections: 섹션은 그룹을 감싸고 있다. 컬렉션 뷰는 이러한 섹션을 다수 가지고 있다.

## 컬렉션 뷰 레이아웃
- 컬렉션 뷰 레이아웃 속성은 두가지가 있는데 FlowLayout과 Custom이 있다. FlowLayout은 OldSchool 방식으로 Compositional Layouts이 나오기 이전에 사용됐다. (물론 지금도 사용 할 수 있음)
- Flow Layout은 스토리보드로도 만들 수 있으나 Compositional Layout는 코드가 꼭 필요하다.

- 컬렉션 뷰의 하나의 셀은 아래 3가지 클래스로 정의된다.
    - NSCollectionLayoutItem
    - NSCollectionLayoutSize
    - NSCollectionLayoutDimension
- 그리고 NSCollectionLayoutDimension은 또 다음 3가지 속성을 제공한다.
    - Fractional
    - Absolute
    - Estimated


```Swift
  func configureLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44.0))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    return .init(section: section)
  }
```
- 위 코드처럼 `UICollectionViewCompositionalLayout`을 정의한다. (FlowLayout이랑은 다른 방법)
- `NSCollectionLayoutItem`을 만들기 전에 해당 사이즈를 정의한다. 셀의 사이즈는 `NSCoㅣllectionLayoutSize`로 결정한다. 이때 각 Dimension으로 Fractional, Absolute, Estimated로 결정할 수 있으며, Fractional은 Item의 경우 Group 크기의 비율로 설정할 수 있고, Absolue는 절대값, Estimate는 추정값이다.Estimated는 절대값과 달리 데이터가 로드되거나 시슽메 글꼴 크기가 변경된 경우와 같이 `런타임에`컨텐츠 크기가 변경될 수 있는 경우 예상값을 사용한다. estimatedSize를 제공하면 시스템이 나중에 실제 값을 계산하여 적용하게 된다.
- 그 다음 Group을 정하는데 Group또한 `NSCollectionLayoutSize`를 통해 사이즈를 정의하고, NSCollectionLayoutGroup에서 디렉션과 사이즈, 그리고 내포하는 아이템들을 가진다.
- 이를 섹션으로 전달하면 기본적인 CompositionalLayout설정이 끝난다.