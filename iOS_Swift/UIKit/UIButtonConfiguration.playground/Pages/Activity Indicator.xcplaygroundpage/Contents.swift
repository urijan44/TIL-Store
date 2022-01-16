import UIKit
import PlaygroundSupport

class UIButtonConfigurationPractice: UIView {
  
  var done = false
  var loggin: Bool = false {
    didSet {
      button.setNeedsUpdateConfiguration()
      button.isEnabled = !loggin
    }
  }
  let button = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    var config = UIButton.Configuration.filled()
    config.imagePadding = 8
    config.imagePlacement = .leading
    config.buttonSize = .large
    config.background.backgroundColor = UIColor.systemTeal
    button.configuration = config
    
    button.addAction(UIAction(handler: { _ in
      self.requestLoggin()
    }), for: .touchUpInside)
//    button.changesSelectionAsPrimaryAction = true
    button.configurationUpdateHandler =  { [unowned self] button in
      var config = button.configuration
      config?.title = "Sign In"
      config?.showsActivityIndicator = loggin
      config?.image = UIImage(systemName: "externaldrive.connected.to.line.below")
      button.configuration = config
    }
    
    addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.centerYAnchor.constraint(equalTo: centerYAnchor),
      button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func requestLoggin() {
    
    loggin = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
      self.loggin = false
    }
    
  }
}

PlaygroundPage.current.liveView = UIButtonConfigurationPractice(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
