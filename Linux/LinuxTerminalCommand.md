# Linux Terminal Command

>Reference [드림코딩 by 엘리](https://youtu.be/EL6AQl-e3AQ)

- man : manual의 약자로 특정 명령어 등의 메뉴얼을 보여준다. 만약 pwd 라는 명령어의 메뉴얼을 보고싶다면 
```
man pwd
```
로 입력할 수 있다. 메뉴얼을 빠져나올때는 `q`를 눌러 빠져나올 수 있다.

- pwd : 현재 위치하고 있는 경로를 출력해준다.
- clear : 윈도우에 출력된 텍스트를 지워서 정리해준다.
- ls : 현재 디렉토리의 리스트를 보여준다.
  - ls -a : 숨긴 파일 까지 다 보여줌
  - ls -l : 권한 이나 파일 소유자 등 상세하게 보여줌
- cd : 디렉토리 이동
  - cd .. : 이전 디렉토리로 이동
  - cd - : 이전에 작헙하던 디렉토리로 이동
- open : 해당 디렉토리를 finder로 열기
- find : 파일 또는 디렉토리를 검색할 수 있다.
```
find . -type file -name "*.json"
find . -type directory -name "1*"
```
json 타입의 파일을 찾을 수 있다
1로 시작하면 폴더를 검색할 수 있다.
- which : 실행 프로그램의 경로를 확인할 수 있다.
```
which swift
```
- touch [file name] : file name라는 이름으로 파일을 만든다. 혹은 파일의 생성일자를 최신날짜로 수정된다.
- cat : 파일의 내용을 확인할 수 있다.
- echo [문자열] : 문자열을 출력할 수 있다.
  - echo "Hello World" > new_file3.txt : Hello World라는 내용을 가진 new_file3.txt 파일을 만든다.
  - echo "Hello Swift" >> new_file3.txt : Hello Swift 라는 내용을 new_file3.txt 내용에 추가한다.

- mkdir : 디렉토리를 만든다.
  - mkdir -p dir1/dir2/dir3 : 한번에 dir3까지 하위 디렉토리 까지 만든다.

- cp [sourceFile] [destinationDirectory] : sourceFile 파일이 destinationDirectory로 복사가 된다.
- mv [sourceFile] [destinationDirectory] : sourceFile 파일이 destinationDirectory로 이동이 된다.
  - 만약 destinationDirectory가 아닌 filename 일 때는 해당 파일로 변경이 되며 해댕 파일이 없는 경우 sourcFile 이름이 destinationFile 이름으로 변경된다.
- rm [fileNAME] : fileName을 삭제한다.
  - rm -r [dirName] : dirName 디렉토리를 통째로 삭제한다(하위 내용가지)

- grep [Keyword] *.txt : txt파일 중 keyword내용이 있는 파일을 찾는다.
```
grep -nir "world" . 
```
현재 폴더를 기준으로 모든 하위 폴더에 있는 파일 중 "world" 내용이 있는 모든 파일을 검색하되 대소문자 상관없이 , 그리고 컨텐츠의 위치를 표시한다.

- export : 환경 변수 를 설정할 수 있다.
```
export MY_DIR="dir1"
cd dir1
cd $MY_DIR
```

- env : 설정한 모든 환경변수 목록을 열람할 수 있다.
- unsert [EnvironmentVariable] : 환경변수를 제거할 수 있다.