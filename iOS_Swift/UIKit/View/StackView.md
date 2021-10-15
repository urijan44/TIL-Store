# Stack View
stack view는 view들을 묶어 표시하는 기능이다.

1. StackView Attributes
 - Axis
    - StackView의 가로 또는 세로를 결정한다(Horizontal, Vertical)
 - Alignment
   1. Fill : 방향에 따라 해당 방향들로 뷰를 늘린다.
   2. Leading : SubView들이 앞머리로 정렬된다.
   3. Top : SubView들이 머리 로 정렬된다.
   4. First Baseline : First Baseline에 따라 SubView들이 정렬된다.
   5. Center : StackView의 center에 맞춰 정렬된다.
   6. Trailing : 뒷꼬리로 정렬된다.
   7. Bottom : 바닥으로 정렬된다.
   8. Last Baseline : Last Baseline으로 SubView들이 정렬된다.
 - Distribute : StackView안의 뷰들의 크기를 설정하는 옵션
   1. Fill : 가능 한 공간을 모두 채우기 위해서 SubView사이즈를 재 조정한다. SubView의 compesttion resistance와 Hugging priority에 따라 증가 하고 줄어든다.
   2. SubView의 기존 크기에 따라 분배한다.
   3. Equal Spacing : SubView들 간격이 일정하게 유지된다.
   4. Equal Centering : SubView들의 센터 간 거리를 같게 유지한다.
 - Spacing : SubView 들간의 간격을 조절한다.