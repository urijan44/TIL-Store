import UIKit
import PlaygroundSupport

class UIButtonConfigurationPractice: UIView {
  
  let button = UIButton(primaryAction: nil)
  
  let deleteComment = { (action: UIAction) in
    print(action.title)
  }
  
  let editComment =  { (action: UIAction) in
                        print(action.title)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    var config = UIButton.Configuration.tinted()
    config.imagePadding = 8
    config.imagePlacement = .leading
    button.configuration = config
    
    button.showsMenuAsPrimaryAction = true
    button.menu = UIMenu(children: [
      UIAction(title: "삭제하기", attributes: .destructive, handler: deleteComment),
      UIAction(title: "수정하기", handler: editComment)
    ])
    button.changesSelectionAsPrimaryAction = true

    button.configurationUpdateHandler =  { button in
      var config = button.configuration
      config?.title = "메뉴선택"
      config?.image = UIImage(systemName: "ellipsis.circle")
      button.configuration = config
    }
    
    addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
}

PlaygroundPage.current.liveView = UIButtonConfigurationPractice(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
