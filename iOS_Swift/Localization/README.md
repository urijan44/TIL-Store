# Localization

- 어플리케이션을 다양한 언어 설정에 맞게 대응하는 것을 `Localization`이라고 한다.
- `국제화`와 용어가 혼용될 수 있는데 국제화는 좀더 구체적으로 정의를 내려보자면 아래와 같다.
  - 하드웨어, 소프트웨어 등의 제품을 언어, 문화권이 다른 환경에서 사용할 수 있도록 지원하는 서비스
  - 사용자가 선택한 기기의 기본 언어에 따라 이루어짐
  - 문화적/환경적인 측면을 고려함

# Apple의 국제화(현지화) 시스템
- Apple API를 활용해 날짜, 길이, 무게, 가격 및 통화 기호와 같이 사용자에게 표시되거나 동적으로 생성되는 값을 모든 로케일에 올바르게 표현할 수 있게 구현
  - 국내와 해외의 날짜 표현 방식, 표준시 차이
  - 숫자 단위의 표현 차이
- 앱에서 사용되는 언어
  - `Localizable.strings` 를 작성해 각 나라와 지역에 맞는 정적 메시지(고정된 텍스트를 제공)
  - `InfoPlist.strings` 를 작성해, 각 나라와 지역에 맞는 권한 요청 문구를 출력
  - `plural.stringsdict` 를 작성해, 각 나라와 지역에 맞는 표현 단위 등을 출력, 언어에 따라 순서가 다르거나 단수나 복수, 숫자 표현 대응이 예시로 있음
- 앱스토어의 메타 데이터
  - 앱의 현지화와 상관없이, 앱스토어 제품 페이지의 메타데이터 내용을 현지화할 수 있다.
  - 단, 앱의 기본 언어 설정의 경우 프로젝트에서 메시지 설정파일(Localizable.strings)대응이 된 국가 중 선태 까능
  - 앱의 기본 언어 설정

# 국제화(Internationalization)
- 앱이 특정 국가나 지역에 종속되지 않도록, 호환성을 위해 앱을 설계하는 과정
- 언어 번역 뿐만 아니라, 국가별 쓰기 방향의 차이, 숫자, 화폐, 날짜 등의 표기 방법, 시간대 등을 고려해 앱을 설계하는 과정
- 이런 설계와 코드를 통해 앱이 현지와(localized)될 수 있음
- i18n
  - Internationalization의 약어
  - multligual system

# 현지화(Localization)
- l10n
  - Localization의 약어
  - 그 국가와 지역에 맞게 앱을 번역하고 리소스 작업을 하는 등 적합하게 구현
  - 날자와 시간 표현을 할 때, 그 나라에 맞는 형식으료 표현


# Localization 수행하기

## 타겟 언어 설정
![](src/projectSet.png)
App - Project - Info - Locatlizations 에서 응하고자 하는 언어를 추가함

## Localizable.strings 파일 생성
Localizable.strings는 A는 B로 번역한다는 데이터가 담긴 파일로 Localizable은 기본값이므로 나중에 별도의 `tableName` 줄 수 있기는 하지만 기본값의 경우 Localizable이기 때문에 틀리면 안됨

![](src/localizable.png)
- `localizable.strings`파일의 file inspector를 보면 사진과 같은 항목이 있는데 `Localize...` 버튼을 누른다.

![](src/localizableAlert.png)
- 그러면 다음과 같은 윈도우가 나오는데 별건 아니고, 정말 지역화 할꺼냐는 일종의 알림문이고, 아래 드롭다운 메뉴에서는 기본으로할 언어를 선택하면 된다., 한국어를 기준으로 먼저 작업한 뒤 영어를 추가하면 되므로, 한국어를 선택하고 localize하자
(드롭다운에서 표시되는 언어는 처음에 타겟 언어 설정할 때 설정한 언어만 표시가 된다.)

- Localizable.strings 파일 내용은 아래와 같다.
```Swift
"search" = "검색";
"calendar" = "캘린더";
"setting" = "설정";
"writeDiary" = "일기쓰기";
"pleaseTypingTitle" = "제목을 입력해주세요";
"saveBar" = "저장";
"dateString" = "yyyy년 MM월 dd일";
```
이런식으로 `search`라는 키는 `검색`으로 번역된다는 뜻이다. 
![](src/localization1.png)
