# DiffableDataSource

- 컬렉션 뷰도 마찬가지로 DiffableDataSource 를 구성할 수 있다.
```Swift
//Laywenderlich
//MARK: - Diffable Data Source
extension LibraryController {
  typealias TutorialDataSource = UICollectionViewDiffableDataSource<TutorialCollection, Tutorial>
  func configureDataSource() {
    dataSource = TutorialDataSource(collectionView: collectionView) { (collectionView, indexPath, tutorial) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TutorialCell.reuseIdentifier, for: indexPath)
              as? TutorialCell else { fatalError("Cannot create new cell") }
      
      cell.titleLabel.text = tutorial.title
      cell.thumbnailImageView.image = tutorial.image
      cell.thumbnailImageView.backgroundColor = tutorial.imageBackgroundColor
      
      return cell
    }
    
    dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
      if let self = self, let titleSupplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                      withReuseIdentifier: TitleSupplementaryView.reuseIdentifier,
                                                                                      for: indexPath) as? TitleSupplementaryView {
        
        let tutorialCollection = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
        titleSupplementaryView.textLabel.text = tutorialCollection.title
        
        
        return titleSupplementaryView
      } else {
        return nil
      }
    }
  }
  
  func configureSnapshot() {
    var currentSnapshot = NSDiffableDataSourceSnapshot<TutorialCollection, Tutorial>()
    tutorialCollections.forEach { collection in
      currentSnapshot.appendSections([collection])
      currentSnapshot.appendItems(collection.tutorials)
    }
    
    dataSource.apply(currentSnapshot, animatingDifferences: false)
  }
}

- Delegate의 경우는 원래 쓰는 델리게이트를 쓰면 되는데 내용이 조금다르다. 원래 DataSource를 사용할때는 아이템 배열에서 indexPath.item 식으로 해당 순서의 인스턴스를 가져오는데 dataSource를 사용하면 아래처럼 쓸 수 있다.
```Swift
//MARK: - UICollectionViewDelegate
extension LibraryController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let tutorial = dataSource.itemIdentifier(for: indexPath),
       let tutorialDetailController = storyboard?.instantiateViewController(identifier: TutorialDetailViewController.identifier, creator: { coder in
         return TutorialDetailViewController(coder: coder, tutorial: tutorial)
       }) {
         show(tutorialDetailController, sender: nil)
    }
  }
}
```
- tutorial 인스턴스는 dataSource.itemIdentifier에 indexPath를 전달하기만 하면 된다.
