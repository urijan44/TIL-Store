# Protocol Initializers

Swift Protocol에서 프로토콜 자체는 초기화 할 수 없지만 초기화에 대한 준수 사항을 정의할 수는 있다.

```Swift
protocol Audio {
  var sampleRate: Double { get set }
  var bitDepth: Int { get set }
  init(sampleRate: Double, bitDepth: Int)
  init?(compressedAudio: Audio)
}
```

이때 Audio를 채용하는 클래스 타입은 반드시 프로토콜의 이니셜라이저를 구현해야 하며 이러한 이니셜 라이저는 앞에 `required`라는 키워드를 붙여야 한다.

```Swift
class Mp3: Audio {
  var sampleRate: Double
  var bitDepth: Int

  init(sampleRate: Double, bitDepth: Int) {
    self.sampleRate = sampleRate
    self.bitDepth = bitDepth
  }
  init?(compressedAudio: Audio) {
    guard sampleRate > 0, bitDepth > 0 else {
      return nil
    }
    self.sampleRate = compressedAudio.sampleRate
    self.bitDepth = compressedAudio.bitDepth
  }
}

var audioFormat: Audio.type = Mp3.type
let mp3Audio = audioFormat.init(sampleRate: 44100, bitDepth: 16)
let compressedAudio = audioFormat.init(compressedAudio: mp3Audio)!
```
