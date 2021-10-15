# View Controller Life Cycle

## 1. viewDidLoad()
- 뷰 컨트롤러의 모든 뷰들이 메모리에 로드되었을 때 호출
- 메모리에 처음 로드될 때 한 번만 호출
- **보통 딱 한번 호출 댕 행위들을 viewDidLoad에 정의함**
- 뷰와 관련된 초기화 작업, 네트워크 호출 등에 용이함

## 2. viewWillApear()
- 뷰가 뷰 계층에 추가되고, 화면에 보이기 직전에 매 번 호출
- **다른 뷰로 이동했다가 돌아올 때 재 호출**
- 뷰와 관련된 추가적인 초기화 작업

## 3. viewDidAppear()
- 뷰 컨트롤러가 뷰가 뷰 계층에 추가 된 후 호출
- 뷰를 나타낼 때 필요한 추가 작업
- **애니메이션을 시작하는 작업**

## 4. viewWillDIsappear()
- 뷰 컨트롤러의 뷰가 뷰 계층에서 사라지기 전에 호출된다.
- 뷰가 생성된 뒤 작업한 내용을 되돌리는 작업
- **최종적으로 데이터를 저장하는 작업**

## 5. viewDidDIsappear()
- 뷰 컨트롤러의 뷰가 뷰 계층에서 사라진 뒤에 호출
- 뷰가 사라지는 것과 관련된 추가 작업

## ETC.
일반적으로 라이프 사이클이


*Root View Controller*

viewDidLoad -> viewWillAppear -> viewDidAppear

(다른 뷰 호출)
viewDidLoad -> viewWillDisappear(RootVC) -> viewWillAppear -> viewDidDisappear(RootVC) -> viewDidAppear

(뷰 복귀)
viewWillDisappear -> viewWillAppear -> viewDidDisappear -> viewDidAppear 

순으로 동작하는데 뷰 계층 불러오는 방식이 만약 `popover`라면 

뷰를 복귀 할 때 RootView의 WillAppear와 DidAppear는 동작하지 않는다.

그리고 popover된 뷰의 경우 드래그로 잡아 내릴 수 있는데 상단을 잡아 내리기 시작하는 순간 WillDisappear를 호출한다. 
도중에 취소하면 다시 willAppear와 DidAppear를 호출한다.