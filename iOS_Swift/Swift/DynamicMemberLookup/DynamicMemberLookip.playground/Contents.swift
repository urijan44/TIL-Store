import UIKit

@dynamicMemberLookup
struct Developer {
  let languages: [String: Int]

  subscript(dynamicMember member: String) -> Int {
    get {
      languages[member] ?? 0
    }
  }
}

let henry = Developer(languages: [
  "swift": 5,
  "cpp": 3,
  "javascript": 1
])

henry.javascript
henry.js
henry.javaScript

struct Point { var x: CGFloat, y: CGFloat }

@dynamicMemberLookup
struct PassthroughWrapper<Value> {
  var value: Value
  subscript<T>(dynamicMember member: KeyPath<Value, T>) -> T {
    get {
      return value[keyPath: member]
    }
  }
}

var point = Point(x: 1024, y: 768)
let wrapper = PassthroughWrapper(value: point)

//wrapper.center

