import UIKit
import PlaygroundSupport

class UIButtonConfigurationPractice: UIView {
  
  let button = UIButton()
  
  var done: Bool = false {
    didSet {
      button.isSelected = done
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    var config = UIButton.Configuration.tinted()
    config.imagePadding = 8
    config.imagePlacement = .leading
    button.configuration = config
    button.changesSelectionAsPrimaryAction = true

    button.configurationUpdateHandler =  { button in
      var config = button.configuration
      config?.title = "오늘의 할일"
      config?.image = button.isSelected
      ? UIImage(systemName: "checkmark.square.fill")
      : UIImage(systemName: "square")
      config?.subtitle = button.isSelected
      ? "01/16 Done!"
      : "01/16"
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
