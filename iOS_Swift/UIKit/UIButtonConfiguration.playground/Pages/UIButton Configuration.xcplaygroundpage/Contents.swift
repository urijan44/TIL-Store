import UIKit
import PlaygroundSupport

class UIButtonConfigurationPractice: UIView {
  
  var done = false
  
  let button = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    var config = UIButton.Configuration.tinted()
    config.imagePadding = 8
    config.imagePlacement = .leading
    button.configuration = config
    button.addAction(UIAction(handler: { _ in
      self.done.toggle()
    }), for: .touchUpInside)
    button.configurationUpdateHandler =  { [unowned self] button in
      var config = button.configuration
      config?.title = "오늘의 할일"
      config?.image = self.done
      ? UIImage(systemName: "checkmark.square.fill")
      : UIImage(systemName: "square")
      config?.subtitle = self.done
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
