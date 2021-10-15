# XML Parser

## 서론(무시해도 됨)
Swift Foundation에 있는 XML Parser는 말 그대로 XML parsing이 가능한 클래스이다. <br>
공공 데이터 포털의 REST API는 JSON으로 제공하는 것도 있지만 XML로 제공하는게 더 많은 것 같다.(체감)<br>
JSON의 경우 JSON Encoder와 Decoder를 이용하면 정말 손쉽고 간편하게 사용할 수 있는데(URL Session과 함께)<br>
XMLParser 클래스는 좀 순서가 다르다 XMLParser 클래스를 생성하고 .parse() 메소드로 파싱을 시작하는데 데이터를 분석하는 것은 Delegate를 통해서 한다.
XML Parser의 사용법을 알아보자

## 사용법
*UIKit 기준으로 설명*

```Swift
  func updateBusInformation(_ requestModel: StationBusListModel) {
    let baseURLString = "http://ws.bus.go.kr/api/rest/arrive/getArrInfoByRoute?"
    guard let serviceKey = Bundle.main.infoDictionary?["StationInfoKey"] as? String else { fatalError("api key not found!")}
    guard let url = URL(string: "\(baseURLString)serviceKey=\(serviceKey)&stId=\(requestModel.stId)&busRouteId=\(requestModel.busRouteId)&ord=\(requestModel.staOrd)") else { fatalError("url convert error")}
    //======= XML Parser
    guard let xmlParser = XMLParser(contentsOf: url) else { return }
    xmlParser.delegate = self
    xmlParser.parse()
    //======
    tableView.reloadData()
  }
 ```
제작중인 출근을 부탁해의 XML parsing에 해당하는 코드로 url을 만들어서 XMLparser 초기화 한다.

parse 메소드를 통해 파싱을 시작하는데 미리 몇가지 작업해야 할 부분이 있다.
```Swift
var currentElement = ""
var xmlDictionary: [String: String] = [:]
```
View Controller 의 프로퍼티로 생성한 것인데 이 것들의 역할은 델리게이트에서 자세히 설명하겠다

```Swift
extension StationDetailViewController: XMLParserDelegate {
  //1
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    currentElement = elementName
    if elementName == XMLKey.itemList.rawValue {
      xmlDictionary.removeAll()
    }
  }
  //2
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == XMLKey.itemList.rawValue {
      let route = StationBusListModel()
      XMLKey.allCases.forEach { key in
        if let value = xmlDictionary[key.rawValue] {
          do {
            try route.codingKeys(key.rawValue, value)
          } catch {
            print(error)
          }
        }
      }
      routes.append(route)
    }
  }
  //3
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    if let key = XMLKey.init(rawValue: currentElement) {
      xmlDictionary[key.rawValue] = string
    }
  }
}
```

코드가 단번에 길어져서 어지러울 수 있는데 차례대로 설명하겠다.


```Swift
func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
```
1. didStartElement로 `<name>` 과 같은 속성을 검출한다. 나머지 파라메터들은 확인을 해봤는데 제대로 된 값을 넘겨 받은 적이 없어서 다른 사용법이 있는지 알아봐야 할 것 같다.


```Swift
func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) 
```

2. 말 그대로 didEndElement `</name>` 닫는 속성을 검출한다.

```Swift
func parser(_ parser: XMLParser, foundCharacters string: String) 
```
3. `<name>`GookBob`</name>` 에서 GookBob에 해당하는 내용을 string 프로퍼티로 넘겨 받는다.

구조가 눈에 들어왔을지 모르겠는데 다시 설명하자면

1. 속성을 연다.
2. 값을 확인한다.
3. 속성을 닫는다.

요 3개 과정을 Delegate를 통해서 전달한다.

그럼 이 메소들 간에서 어떻게 값을 객체에 전달할 수 있을까. 여기서 앞에서 선언한 뷰 컨트롤러 클래스의 두 프로퍼티를 활용한다.
```Swift
var currentElement = ""
var xmlDictionary: [String: String] = [:]
```
이 녀석들인데 의사코드로 작성하자면

1. 속성을 연다. `currentElement`에 현재 속성 이름을 저장한다. `name`이라고 하겠다. `xmlDictionary`에 있는 값을 초기화 한다.
2. 값을 확인한다. `GookBob`이 들어있다. `xmlDictionary`에 `name`을 키로 `GookBob`을 값으로 저장한다.
3. 속성을 닫는다. `xmlDictionary`있는 값을 객체를 생성하는데 사용한다.

요 3과정으로 XML 문서를 다 읽을 때 까지 반복 한 후 parsing 과정을 종료한다. 다시 전체 코드를 보면

```Swift

fileprivate enum XMLKey: String, CaseIterable {
  case itemList = "itemList"
  case adirection = "adirection"
  case busRouteId = "busRouteId"
  case rtNm = "rtNm"
  case stId = "stId"
  case stNm = "stNm"
  case staOrd = "staOrd"
}

extension StationDetailViewController: XMLParserDelegate {
  //1
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    currentElement = elementName
    if elementName == XMLKey.itemList.rawValue {
      xmlDictionary.removeAll()
    }
  }
  //2
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == XMLKey.itemList.rawValue {
      let route = StationBusListModel()
      XMLKey.allCases.forEach { key in
        if let value = xmlDictionary[key.rawValue] {
          do {
            try route.codingKeys(key.rawValue, value)
          } catch {
            print(error)
          }
        }
      }
      routes.append(route)
    }
  }
  //3
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    if let key = XMLKey.init(rawValue: currentElement) {
      xmlDictionary[key.rawValue] = string
    }
  }
}
```

이 경우 들어오는 속성들을 일일이 문자로 작성하기에는 너무 불편해서 열거형을 사용했다.


## 대안
내용을 보면 알겠지만 코딩 하는데도 준비된 JSON 인코더, 디코더에 비해서 상당히 불편하고 Session의 response를 받을 수 있는지도 모르겠다. XMLParser는 iOS 2.0 objective-C 기반의 클래스로 기술적으로 오래되었다고 볼 수 있다.
이를 친절하게 JSON Codable 처럼 라이브러리를 제작해 준 개발자가 있으므로 링크를 첨부한다.
https://github.com/ShawnMoore/XMLParsing