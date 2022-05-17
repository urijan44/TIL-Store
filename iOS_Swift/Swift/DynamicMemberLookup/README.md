## Intro

Swift로 된 라이브러리를 구경하다 보면, Class의 @Attribute로 `dynamicMemberLookup`이라는 것이 붙은 것을 본 적이 있다.

`dynamicMemberLookup`이 무엇인지, 어떻게 쓰이는지 알아보자

## What is Dynamic member lookup

먼저 이것이 무엇인지만 간략하게 설명하자면 '실제 객체에 존재하지 않는 프로퍼티(멤버 변수)를 Dot Syntex로 접근하는 문법\` 으로 몬 쌉소린가 싶습니다. 하지만 이 개념을 알고 난 뒤에는 똑같이 설명하게 되실 겁니다.

우선 당연한 예제를 하나 볼게요

```
struct Developer {
  let languages: [String: Int]
}

var henry = Developer(languages: [
  "swift": 5,
  "cpp": 3
])

henry.languages["swift"] // Optional 5
```

Developer 객체는 사용할줄 아는 언어와 그 경력이 Dictionary로 정의되어 있습니다. 만약 swift 언어 경력을 알고싶다면

\`henry.languages\["swift"\]\` 와 같이 작성해서 languages에 접근해볼 수 있곘고 결과는 Optional 5 일겁니다. 그렇죠?

당연하지만

![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FFByl6%2FbtrCqnSpWwf%2FxD5Xr6K4dek7LCdhHQvlY1%2Fimg.png)

이렇게는 못가져 올겁니다. Developer 구조체는 swift라는 멤버 변수를 가지고 있지 않기 때문이죠

`Dynamic Member Lookup` 문법은 이걸 가능하게 합니다.

## Implementation

일단은 `Developer`를 아래와 같이 고쳐볼게요

```
@dynamicMemberLookup
struct Developer {
  var languages: [String: Int]

  subscript(dynamicMember member: String) -> Int {
    get {
      languages[member] ?? 0
    }
  }
}
```

하나씩 차근차근 보겠습니다.  
우선 @Attribute로 `@dynamicMemberLookup` 이란게 붙었습니다. 해당 객체가 dynamicMemberLookup를 지원하겠다는 뜻입니다.

그 다음은 뜬금없이 subscript 문법이 들어와 있는데요, subscript문법을 통해서 languages에 바로 접근하고 있습니다.

dynamicMemberLookup 을 잠깐만 잊어볼게요, subscript문법을 작성했으니 다음과 같이 swift 경력을 얻을 수 있습니다.

`henry[dynamicMember: "swift"]` 그렇죠?

subscript 에서 외부 접근 레이블인 dynamicMember는 사실 dynamicMemberLookup의 구현 사항입니다. subscript문법만 놓고 생각하면 외부 레이블이 뭐든 상관 없을 겁니다. 

dynamicMemberLookup은 지금까지 작성한 내용을 바탕으로 dot syntex로 swift에 접근할 수 있습니다.

![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fbk4VBr%2FbtrCoWBj04f%2FZsRoGMPdBNswR35skmCg5K%2Fimg.png)

아까와는 달리 컴파일이 되면서 5라는 정수가 튀어나오죠?

henry라는 Developer의 멤버 변수에는 swift는 없지만, 멤버 변수처럼 접근 할 수 있습니다. 바로 subscript 문법을 이용해서요! 이제 아시겠죠?

## Point

이처럼 실제로 존재하지 않는 속성을 dot syntex로 접근하는 것은 굉장히 편리하지만, 런타임에 결과를 확인할 수 있기 때문에 신중해야 합니다.

예를들어 javascript에 경력에 대해서 접근하려고 하는데, js인가요 javascript인가요 javaScript인가요 아니면 JavaScript인가요?

```
let henry = Developer(languages: [
  "swift": 5,
  "cpp": 3,
  "javascript": 1
])
```

![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FpGDWd%2FbtrCqaSYfnw%2FpA5coIwHNoC8IAukgEboqK%2Fimg.png)

실제로 javascript의 경력이 있더라도 조금만 잘못 입력하면, 원하는 값이 나오지 않을 수 있습니다. 컴파일 타임에 확인이 불가능 하니 휴먼 에러가 발생할 확률이 높을 뿐더러, 어떤 식으로 프로퍼티가 존재할지 직관적이지도 않고, 자동완성 기능도 기대할 수 없습니다.

그런데 이를 보완하기 위한 방법이 있는데요

```
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
```

이런식으로 래퍼를 만들어서 KeyPath를 사용하면

![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbA0SQJ%2FbtrCp5R6YAd%2FHPpibJr5Jx7vVjkfR5ZpVk%2Fimg.png)

사진 처럼 자동완성의 도움도 받을 수 있고

존재하지 않는 프로퍼티에 접근하면 컴파일 타임에 이를 확인 할 수도 있습니다.

![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FcSedSI%2FbtrCp6KeFed%2FZkizYp0oWkj5CI858IgAU0%2Fimg.png)

경우에 따라서는 편리하게 사용할 수 있지만, 래퍼를 통하더라도 남용하는 것은 주의하는게 좋을 것 같습니다.

참고

[The Swift Programming Language](https://books.apple.com/kr/book/the-swift-programming-language-swift-5-6/id881256329)