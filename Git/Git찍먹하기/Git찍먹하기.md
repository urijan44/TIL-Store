# Git

## 깃의 필요

내가 깃을 처음 접한 것은 개발은 아니었고 회사에서 프로젝트를 진행할 때 관련 소스들을 통합하고 버전을 관리할 일이 있어서 접하게 되었다. 당시에는 소스 통합이니, 버전 관리니 그런 개념 보다는, 당시에는 수십개가 넘어가는 revision 파일이 감당이 안되었고, 언제 작성했던 버전으로 돌아가야 하는데 파일이 너무 많아지니 무슨 파일인지 분간도 가지 않았고, 보존했어야 되는 버전이 편집이 되어서 낭패를 보는 경우도 있었다. 

그래서 찾게 된 개념이 버전관리 프로세스다.  

핵심은 이전 작업 내용과 변경사항에 대한 정보를 저장할 수 있고, 다른 사람이 작업하는 것과 내가 작업하는 오버라이딩 되는 것의 방지, 그리고 최신파일로 작성하기(작업 파일을 보내주면 최신 파일로 안하고 옛날 파일에다 작업하는 팀원도 있었다)가 가능했다.

## 깃의 흐름도

![Untitled](Git%20a8b12bf65f9f48a588c78413bc327a7c/Untitled.png)

깃의 전체 흐름을 보면 사진과 같은 모양인데 용어가 낯설다고 두려워 하지 않아도 된다. 정말 간단하게 풀어보자면

- Remote Repository : 웹드라이버라고 생각하면 된다. 구글 드라이브와 같은 존재로 작업자들이 구글 드라이브에서 파일을 내려받아 작업한다고 볼 수 있다. 웹드라이버에 있는 파일을 다운로드 받아 수정했다고 해서 웹드라이버에 존재하는 파일 자체가 수정되는 것은 아니다.
- Local Repository : 내 컴퓨터에 저장된 것이라고 보면된다. 원격 저장소에 내려 받아 내 다운로드 폴더로 들어온 상태이다. 그리고 보통은 원격 저장소에서 다운받아 풀어놓은 디렉토리로 보면 된다.
- Staging Area : 내 컴퓨터에 최종 파일로 등록되기 전 구역으로 자세한 내용은 나중에 설명하는 것이 좋다. 지금은 Staging Area 자체를 잊고 있어도 된다.
- Working Directory : 작업중인 공간으로 인식하면 된다.

## 워크플로우

이제 쉽게 말하자면 원격 저장소에서 파일을 가져와서 작업하고 그를 다시 원격 저장소에 올리는 것이 전체 깃의 흐름이라면 실제 워크플로우는 어떻게 될까?

![Untitled](Git%20a8b12bf65f9f48a588c78413bc327a7c/Untitled%201.png)

 

왼쪽 위 Origin Remote Repository부터 보자

1. 원래 원격 저장소로부터 Fort한다.
2. 원격 저장소 를 Clone하여 지역 저장소를 만든다.
3. 분기 지역저장소를 만든다.
4. 작업 후 파일을 추가한다.
5. 커밋한다.
6. 분기 원격 저장소에 푸쉬한다.
7. 풀 리퀘스트 한다.

위 과정을 통해서 작업물을 안전하게 복사하고, 작성하고 업로드 하며 통합할 수 있다.

## 짧게 전체 과정 실습해보기

1. 우선 원하는 저장소를 포크해오자 

특별히 원하는 저장소가 없다면 시험삼아 만든 노래가사를 저장하는 깃을 이용해보자

[https://github.com/urijan44/SongLyrics-GitPractice.git](https://github.com/urijan44/SongLyrics-GitPractice.git)

이제부터는 코드는 terminal에서 작성되는 git command이다. 콘솔에서 작성하면 된다.

terminal 커맨드는 유닉스 커멘드로 유닉스/리눅스 커멘드를 잘 모른다면 유튜브 드림코드 엘리님 영상을 참조하거나 해당 영상을 정리한 깃을 보길 바란다. [이동하기](https://github.com/urijan44/TIL-Store/blob/master/Linux/LinuxTerminalCommand.md)

```swift
git clone https://github.com/<your-name>/<repository-name>.git
```

- git : git 프로그램의 이름으로 당연하지만 모든 git 명령어는 git으로 시작한다.
- clone : 해당 git을 clone 한다는 명령어로 현재 디렉토리에 로컬 저장소로 복제를 뜻한다.
- https://~.git : git 주소로 깃헙에서는 초록석 코드 버튼을 누르면 나오는 주소가 바로 그것이다.

![Untitled](Git%20a8b12bf65f9f48a588c78413bc327a7c/Untitled%202.png)

clone에 성공하며 다음과 같은 내용이 출력된다.

```powershell
Cloning into 'programmer-jokes'...
remote: Enumerating objects: 7, done.
remote: Total 7 (delta 0), reused 0 (delta 0), pack-reused 7
Receiving objects: 100% (7/7), done.
```

클론 후 디렉토리를 보면 해당 저장소의 저장소가 내 디렉토리에 들어 있을 것이다.

이제 내용을 수정할 것인데 그전에 원본의 내용을 망치지 않기 위해서 별도의 작업 공간인 **Branch**를 만들자

## Creating a branch

Branch는 번역하면 '나뭇가지'인데 나뭇가지들은 뿌리로 가기전에 몸통이라는 것을 통해서 간다. 그리고 뿌리가 부러지거나 손상이 되도 원본인 몸통은 문제가 없다. 그런의미로 Branch를 이해하자

```powershell
git branch henry
```

- branch는 branch를 생성하는 명령어이다.
- henry는 branch의 이름으로 자유롭게 생성하면 된다. 지금은 그냥 이름으로 했지만 설명이 조금 들어간 이름이라면 여러 branch를 가지더라도 어떤 목적으로 분기를 했는지 알기 쉬울 것이다.

branch의 목록은 다음 명령어로 알 수 있다.

```powershell
git branch
```

```powershell
* main
  henry
```

현재 위치해 있는 branch앞에는 *마커가 붙어있다. 우리는 henry라는 분기를 만들어서 거기서 작업하고 싶으므로 해당 branch로 이동하자

```powershell
git checkout henry
```

이를 체크아웃 이라고 하며 성공적으로 branch를 이동했다면 다음과 같이 출력된다.

```powershell
Switched to branch 'henry'
```

존재하지 않는 branch라면 아래처럼 출력된다.

```powershell
error: pathspec 'david' did not match any file(s) known to git
```

사용자 환경에 따라 다르지만 본인의 terminal 설정에서는 현재 branch를 표시해주기도 한다.

[command 꾸미기](https://ooeunz.tistory.com/21) (윤자이님 기술블로그)

음악가사를 저장하는 txt파일과 해당 README에 새로 만든 txt파일의 인덱스를 작성하고 저장하자.

```powershell
git status
```

```powershell
On branch henry-joke
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md
```

내가 수정한 README.md가 modified 되었다고 나온다. 이를 저장소에 추가하도록 준비 시킬려면 다음과 같이 입력한다.

```powershell
git add README.md
```

add의 명령어가 추가한다는 단어라서 새로 생긴 파일에만 적용 된다고 생각할 수 있지만 정확히는 내가 추가한 파일을 Stage에 등록한다는 의미로 파일을 추가해서 생긴 add가 아니라는 것을 알고있자.

만든 파일들을 한번에 add하고 싶으면 terminal에서 아래처럼 입력할 수 있다.

```powershell
git add .
```

이제 이를 로컬 저장소에 저장을 하기 우선 **커밋**을 해야한다.

## 변경사항 커밋

파일을 추가해서 바로 저장을 해도 되지만 Git은 그런 허접한 사고방식은 하지 않는다. 만약 바로 파일을 저장하기 전에 수정할 사항이 생각났거나 한다면 어떻게 되는걸까? 그래서 파일을 생성하고 add했지만 바로 반영이 되지 않는 이유이다. 커밋은 "다 확인했어? 그럼 이것만 올리면 되지?" 라고 물어보는 과정으로 보면 된다. 이때 우리는 추가하는 작업 전체 내용에 메시지를 통해 메모를 할 수 도 있다.

```powershell
git commit -m "비가오는날엔 등록"
```

성공적으로 커밋하게 되면

```powershell
[henry 99334d2] 비가오는날엔 등록
 2 files changed, 51 insertions(+)
 create mode 100644 "\353\271\204\352\260\200\354\230\244\353\212\224\353\202\240\354\227\224.txt"
```

커밋 후 나오는 메시지를 차근히 읽어보자

- [henry ~] : henry는 분기(Branch)의 이름이다.
- [~ 99334d2] : 이는 커밋의 고유 식별자(ID)이며 **커밋 해시** 라고도 부른다. 이 식별자를 통해 추후에 이 커밋만을 컨트롤 할 수 있게된다.
- 비가오늘날엔 등록 : 커밋할때의 메시지가 출력된다.
- 2개의 파일이 바뀌었고 51개 줄의 삽입이 있었다고 한다.
- create mode : 새로운 파일 만드는 상태에서 발생하며 \353\271\204... 로 쭈욱 작성된 것은 이상한게 아니라 비가오는날엔.txt 파일이다. 한글이 그렇게 표시되는 것 뿐으로 놀라지 말자

## 변경사항 푸시

이제 로컬에서의 작업은 끝냈으므로 원격 저장소에 Push라는 것을 해보자. 내가 여태까지 작성한 것을 웹에 업로드 하는 작업이라고 생각하자.

```powershell
git push --set-upstream origin henry
```

명령어가 꽤 긴데, 분기에서 푸시할때는 이렇다. 길다고 외우려고는 하지말자 사실 git push만 입력해도 깃이 자동으로 위와 같이 입력하라고 출력해준다.

- push : 로컬 저장소의 변경사항을 서버에 저장하는 명령어이다.
- —set-upstream : 로컬 저장소와 원격 저장소 간의 이 분기에 대한 추적 링크를 형성하도록 하는 명령어이다.
- origin : 원격 저장소를 참고하는 규칙이다.
- henry : 푸시하려는 분기의 이름이다.

푸시 하고 나면 아래와 같이 내용이 출력된다.

```powershell
Enumerating objects: 6, done.
Counting objects: 100% (6/6), done.
Delta compression using up to 8 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 1.16 KiB | 1.16 MiB/s, done.
Total 4 (delta 0), reused 0 (delta 0), pack-reused 0
remote:
remote: Create a pull request for 'henry' on GitHub by visiting:
remote:      https://github.com/urijan44/SongLyrics-GitPractice/pull/new/henry
remote:
To https://github.com/urijan44/SongLyrics-GitPractice.git
 * [new branch]      henry -> henry
Branch 'henry' set up to track remote branch 'henry' from 'origin'.
```

깃을 통해 원격 저장소에 변경사항을 성공적으로 푸시했다. 아직 끝난 것은 아닌데 우리는 henry라는 분기에 푸시를 했고 이 분기는 우리가 원본 작업을 망치지 않기 위해 별도로 생성한 분기이다. 이 내용을 원본 저장소에 통합하고 원본 저장소 담당자가 이를 가져오기를 요청하는 **pull request** 라는 작업을 수행해야 한다.

## Creating pull request

주소에 해당하는 깃헙으로 가보자 [이동하기](https://github.com/urijan44/SongLyrics-GitPractice)

![Untitled](Git%20a8b12bf65f9f48a588c78413bc327a7c/Untitled%203.png)

여기서 branches를 눌러보면

![Untitled](Git%20a8b12bf65f9f48a588c78413bc327a7c/Untitled%204.png)

Your branches 라는 항목이있다.

New pull request 라는 항목을 눌러보자!

![Untitled](Git%20a8b12bf65f9f48a588c78413bc327a7c/Untitled%205.png)

메인에 내 분기를 통합하기를 요청하는 풀 리퀘스트이다.

내용에 본인이 한 작업에 대해 적절히 쓰고 Create Pull Request 버튼을 클릭

![Untitled](Git%20a8b12bf65f9f48a588c78413bc327a7c/Untitled%206.png)

친절하게도 내가 만든 분기가 충돌하는 내용이 없기 때문에 초록색 아이콘이 뜬다. 이 화면이 나오기 전에 이를 검사하는 동안 황색으로 표시될 수 있다. 잠깐 기다려 보자 크게 문제가 없다면 녹색으로 바뀌게 될 것이다.

위 과정을 통해 당신과 내가 해당 깃에 가사를 등록하는 '협업'을 안전하고 정확하게 이루어 냈다. 

깃에 대해 간단히 찍먹을 해보았지만, 전체적인 워크플로우를 시행함으로써 앞으로 깃에대한 더 깊은 이해를 할 수 있다고 생각한다.