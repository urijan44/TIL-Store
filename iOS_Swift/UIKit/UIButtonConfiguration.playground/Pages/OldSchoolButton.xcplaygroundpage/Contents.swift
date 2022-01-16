import UIKit
import PlaygroundSupport

class UIButtonConfigurationPractice: UIView {
  
  var done = false
  var loggin: Bool = false {
    didSet {
      
      
    }
  }
  let button = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    button.setTitle("Sign In", for: [])
    button.backgroundColor = .systemTeal
    button.layer.cornerRadius = 8
    button.addAction(UIAction { _ in
      self.requestLoggin()
    }, for: .touchUpInside )
    button.isEnabled = false
    
    addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.centerYAnchor.constraint(equalTo: centerYAnchor),
      button.widthAnchor.constraint(equalToConstant: 200),
      button.heightAnchor.constraint(equalToConstant: 44)
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
