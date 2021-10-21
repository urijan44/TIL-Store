# Memory Management
> Reference [Swift Apprentice](https://www.aladin.co.kr/shop/wproduct.aspx?ItemId=102908101)

# Intro

Swift는 Autometic Reference Counting(ARC)를 통해 사용자가 특별히 메모리를 관리하지 않아도 메모리를 잘 관리해주기는 하지만 그것만으로는 부족한 경우가 있다.

ARC가 개체 간 적절한 관계를 추론할 수 없는 경우가 있는데 여기서 바로 볼 수 있는 키워드가 **참조 사이클(Reference Cycle)** 이다.

# 클래스에 대한 참조 주기
클래스의 인스턴스 끼리 서로 강한 참조를 하게 되면 메모리 누수로 이어지는 Strong Refernece Cycle을 만들게 된다. 어느 한쪽이 비활성화 되어도 참조 카운팅 회수가 0이 되지 않게 되기 때문이다.

```Swift
class Audio {
  let title: String
  var editor: Editor?

  init(title: String) {
    self.title = title
  }

  deinit {
    print("Audio is end")
  }

}

class Editor {
  var trackName: String
  var tracks: [Audio] = []

  init(trackName: String) {
    self.trackName = trackName
  }

  deinit {
    print("\(trackName) is Edited")
  }
}
```
위 예제에서는 오디오 에디터가 tracks로 오디오 배열을 가지고 있다. 오디오 또한 에디팅 될 수 있는 기능이 있으므로 프로퍼티로 이를 가지고 있다.


```Swift
do {
  let music = Audio(title: "Wasted Nights")
  let editor = Editor(trackName: "Eye of the Storm 1")
}
```
평범하게 이렇게만 하면 do 블록을 벗어나면 두 인스턴스는 사라지게 된다. 참조 카운터도 0이 될 것이다.

```Swift
do {
  let music = Audio(title: "Wasted Nights")
  let editor = Editor(trackName: "Eye of the Storm 1")
  music.editor = editor
  editor.tracks.append(music)
}
```
위 코드를 실행 시켜 보면 do 블록이 끝났음에도 둘다 deinit이 동작하지 않는데 이는 참조 사이클 때문에 참조 카운팅이 0이 되지 않아 deinit을 호출하지 않기 때문에다. 참조 주기는 쉽게 이러한 상황처럼 서로 다른 인스턴스가 상호에대해 참조하고 있을 때 발생한다.

이를 이제 해결해보자

## Weak refereces
Weak Reference라고 하는데 이는 개체의 소유권에 대해 아무런 역할도 하지 않는 참조이다. 약한 참조는 개체가 사라질 때 자동으로 감지할 수 있는데 weak로 선언할때 옵셔널로 선언하는 이유이다.

위 예제 코드에서 Audio는 꼭 편집기에 들어가지 않을 수 있으므로 옵셔놀로 선언 되어 있는데 여기서 wear로 선언해 보겠다.

```Swift
var editor: Editor?
```
이렇게 수정해서 작성하면 인스턴스가 서로 참조를 상황임에도 do 블록이 끝난 뒤 둘다 deinit가 실행 된다.
weak reference는 상수로 정의할 수 없다! 개체가 사라지면 nil이 될것이기 때문에

## Unowned references
비소유 참조라고 하는데 이는 또 한가지의 참조 주기를 해결하는 방법이다. 비소유 참조는 개체의 참조 카운팅을 애초에 변경하지 않는 다는 점에서 weak refereces와 유사하다.

하지만 핵심적으로 다른 점은 바로 항상 값을 갖는 것을 목적으로 한다는 것이다. 따라서 옵셔널로 선언할 수 없다. 

```Swift
class Audio {
  let title: String
  let composer: Composer
  weak var editor: Editor?

  init(title: String, composer: Composer) {
    self.title = title
    self.composer = composer
  }

  deinit {
    print("Audio is end")
  }
}

class Composer {
  let name: String
  var songList: [Audio] = []
  
  init(name: String) {
    self.name = name
  }
  
  deinit {
    print("written by \(name) ")
  }
}
```
오디오는 작곡가가 작곡을 할 것이기 때문에 옵셔널이 아니다

```Swift
do {
  let composer = Composer(name: "Taka")
  let music = Audio(title: "Wasted Nights", composer: composer)
  let editor = Editor(trackName: "Eye of the Storm 1")
  music.editor = editor
  editor.tracks.append(music)
  composer.songList.append(music)
}
```
이렇게 쓰게되면 editor는 정상적으로 deinit을 호출하지만 composer와 music은 또 상호참조로 해제되지 않는다.

아래처럼 수정해서 쓰자

```Swift
class Audio {
  let title: String
  unowned let composer: Composer
  weak var editor: Editor?

  init(title: String, composer: Composer) {
    self.title = title
    self.composer = composer
  }

  deinit {
    print("Audio is end")
  }
}
```

# Reference cycles for closures
클로저에 의한 참조 주기는 어떻게 될까

클로저는 인클로저 스코프안에서 값을 캡처하는데 이러한 캡처로 값을 유효하게 사용하기 위해 수명이 연장되게 된다. 이러한 수명 연장은 자칫하면 참조 주기를 발생시킬 수 있다.

```Swift
  lazy var description: () -> String = {
    "\(self.title) by \(self.composer.name)"
  }
```
오디오에 다음과 같은 프로퍼티를 추가하자 그리고 do 블록 안에서 music인스턴스 선언 후 바로 해당 값에 접근 한 뒤 코드를 실행시키면 music의 deinit이 동작하지 않는다. self 값을 캡처하게 되어 강한 참조 사이클을 생성하게 되었기 대문이다.

해당 사이클을 해결하기 위해서는 Capture list에 대해서 알아야 한다.

> Swift를 쓰다보면 클로저 내부에서 값을 쓸려면 self로 접근해야 하는 것은 알 것이다. 이는 그 개체에 대해 캡처하고 있다고 받아들이면 될 것 같다.



## Capture lists
캡처 리스트는 클로저가 참조하는 인스턴스의 수명을 연장하는 방법을 정확히 제어하는데 도움이 되는 언어의 기능이다.
캡처 리스트는 변수의 목록이며 클로저 시작 부분에서 인수 앞에 나타난다!

```Swift
var counter = 0
var f = { print(counter) }
counter = 1
f()
```
f()는 counter에 대한 참조를 가지고 있기 때문에 f()를 호출하는 시점에서 counter값을 1로 가지고 있다.

```Swift
counter = 0
f = { [c = counter] in print(c) }
counter = 1
f()
```
괄호 안에 있는 것이 캡처 리스트이며, counter를 c로 새 변수를 선언했지만 이를 꼭 새로운 변수를 만들필요 없다. 자체적으로 counter라는 로컬 변수를 만들기 때문에 아래처럼 쓸 수 있다.
```Swift
counter = 0
f = { [counter] in print(counter) }
counter = 1
f()
```
이렇게 쓰면 f()안에서 counter는 값이 복사된 개체이기 때문에 f()를 호출하는 시점에서 1을 프린트하게 된다.

그래서 앞에서 작성했던 `lazy var description: () -> String`에서 [self]로 값을 캡처해서 실행해보면?

어라 여전히 Audio의 deinit가 동작하지 않는다. 왜일까

앞에 작성한 f()와 카운터 예제는 값이 변수이고, Audio 안에 composer는 상수로 선언되어 있다. 캡처 리스트는 클로저가 참조 타입과 함께 캡처된 변수 내부에 저장된 현재 참조를 캡처하고 저장하도록 한다. 이 참조를 통해 개체에 적용된 변경 사항은 여전히 클로저 외부에서 볼 수 있게 된다.

여기서 나오는게 unowned self이다.

## Unowned self
composer는 Audio에서 let으로 선언되어 있기 때문에 description이 해제 된 뒤에도 nil이 될 수 없기 때문에 강한 참조 사이클이 발생하게 된다. 따라서 이를 해결하는 방법은 옵셔널이 아닌 값의 참조 사이클을 해결하기 위해 unowned를 개체에 했듯이 캡처 리스트에도 똑같이 적용한다.

```Swift
  lazy var description: () -> String = { [unowned self] in
    "\(self.title) by \(self.composer.name)"
  }
```
코드를 위처럼 수정하게 되면 Audio의 deinit이 정상적으로 동작하게 된다.

## Weak self
```Swift
var audioDescriotipn: () -> String
do {
  let composer = Composer(name: "Taka")
  let music = Audio(title: "Wasted Nights", composer: composer)
  
  audioDescriotipn = music.description
}
print(audioDescriotipn())
```
아래와 같은 코드를 작성하게 되면 플레이그라운드에서 에러가 발생하게 되는데 do 블록 안에서 composer와 music이 메모리 해제 되어버렸기 때문에 주소에 접근할 수 없기 때문이다.

여기서 해볼 수 있는 것은 description에서 unowend에서 weak로 바꿀 수 있다.

그러면 이 순간 self가 옵셔널로 되고 do블록 실행 결과에서 nil by nil이라는 독특한 내용이 출력된다.
weak로 인해 코드가 nil이 되기 때문에 에러는 나지 않지만 이 결과는 원하는 결과는 아니다.

## The weak-strong pattern
self가 옵셔널이기 때문에 guard문으로 바인딩 하게 되면 이는 더이상 self가 nil이 될 수 없는 strong으로 만들어 버린다. self가 nil인 경우 메모리 에러가 발생하는게 아니라 우리가 정의한 문구를 내보낼 수 있게 된다.
```Swift
lazy var description: () -> String = { [weak self] in
    guard let self = self else { return "The Audio is no longer avaliable"}
    return "\(self.title) by \(self.composer.name)"
  }

 /* 
Audio is end
written by Taka 
The Audio is no longer avaliable
*/
```


# 핵심 
- 참조가 라이프사이클 특정 지점에서 nil이 될 수 있는 경우 약한 참조를 사용하여 사이클을 해결!
- 참조가 옵셔널이지 않는 경우 그리고 nil이 되지 않을 거라고 확신할 수 있는 경우 비소유 참조를 사용할 수 있다.
- 참조 유형의 클로저 내에서는 self를 사용한다. 이는 Swift의 컴파일러가 순환 참조를 만들지 않도록 주의애햐 한다고 암시하는 방식이다., 즉 클로저 안에서 self를 보면 참조 사이클이 발생 가능성을 확인해야 한다.
- 캡처 리스트는 클로저에서 값과 참조를 캡처하는 방법이다.
- weak-strong pattern으로 약한 참조를 강한 참조로 변환한다.