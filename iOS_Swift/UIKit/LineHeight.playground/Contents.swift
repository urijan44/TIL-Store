import UIKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
let label = UILabel()
view.addSubview(label)
let greeting = "안녕하세요~\nHello, Swift!"
label.numberOfLines = 0
label.translatesAutoresizingMaskIntoConstraints = false

NSLayoutConstraint.activate([
  label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
  label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
])

let style = NSMutableParagraphStyle()
let fontSize: CGFloat = 20
let lineheight = fontSize * 1.6  //font size * multiple
style.minimumLineHeight = lineheight
style.maximumLineHeight = lineheight

label.attributedText = NSAttributedString(
  string: greeting,
  attributes: [
    .baselineOffset: (lineheight - fontSize) / 4,
    .paragraphStyle: style
  ])
label.font = .systemFont(ofSize: fontSize)
label.backgroundColor = .systemTeal

let textView = UITextView()
view.addSubview(textView)
textView.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
  textView.topAnchor.constraint(equalTo: label.bottomAnchor),
  textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
  textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
  textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
])


textView.backgroundColor = .systemIndigo
textView.textColor = .white
textView.attributedText = NSAttributedString(
  string: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
  attributes: [
    .paragraphStyle: style
  ])
textView.font = .systemFont(ofSize: 20)
PlaygroundPage.current.liveView = view
