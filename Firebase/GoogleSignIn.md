# Google Sign In
Google Sign In은 구글에서 제공하는 OAuth로 어플리케이션 사용시 흔히 보이는 구글 계정으로 로그인 하기가 바로 그거다.
별도의 Backend 서버에서 OAuth를 사용할 수 있지만 나는 개인이고 서버가 따로 없으므로 Firebase를 통해 사용했다.

## 설치하기(Swift Package Manager)

https://github.com/google/GoogleSignIn-iOS

해당 깃헙 레포지토리를 Package Dependencies에 추가한다. <br>
[Xcode13에서 패키지 설치하기](PackageInstall.md)

*바로 밑에 셋업하기로 넘어가기 전에 OAuth 서버 클라이언트 ID를 가지고 와야 한다.
그리고 다음은 프로젝트에 URL스키마를 추가해야 하는데 해당 내용은 구글 문서에서 확인하는것이 정확하겠다*<br>
https://developers.google.com/identity/sign-in/ios?authuser=0

## 셋업하기
AppDelegate에 에 다음을 추가한다.
```Swift
@available(iOS 9.0, *) func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
  return GIDSignIn.sharedInstance.handle(url)
}
```
끝이다. 6.0.0 이전에는 GIDSignInDelegate를 추가하고 6.0.0 부터 M1 mac에서 시뮬레이터와 SPM을 정식으로 지원했고, 이때부터 iOS GoogleSignIn이 오픈소스로 변경 되었다고 한다.
그리고 해당 버전 변경사항으로 GISSIgnInDelegate가 삭제가 되었다. 그래서 AppDelegate에 작성하는 내용은 저게 끝이다.

## 구글 로그인 하기
이제 구글 로그인 버튼이 있는 곳에 아래 내용을 그대로 써주기만 하면 된다.
```Swift
 @IBAction func googleLoginButtonTapped() {
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }

    // Create Google Sign In configuration object.
    let config = GIDConfiguration(clientID: clientID)

    // Start the sign in flow!
    GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [weak self] user, error in
      guard let self = self else { return }
      if let error = error {
        print("Error Google Sign In \(error.localizedDescription)")
        return
      }

      guard
        let authentication = user?.authentication,
        let idToken = authentication.idToken
      else {
        return
      }


      let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                     accessToken: authentication.accessToken)
      // 여기까지가 GoogleSignIn 내용

      // 아래는 사용하는 인증서버 로그인 처리를 하면 된다.
      // 여기서는 Firebase Auth를 사용하므로 인증정보를 Auth.auth().signIn(with:)으로 넘겨주었다.
      Auth.auth().signIn(with: credential) { _, _ in
        self.showMainViewController()
      }
    }
 }
```
이전과는 달리 웹뷰 페이지를 따로 설정해줄 필요가 없다.

## 로그아웃
Firebase를 사용하는 경우 GIDSignIn의 로그아웃은
```Swift
let firebaseAuth = Auth.auth()
do {
  try firebaseAuth.signOut()
} catch let signOutError as NSError {
  print("Error signing out: %@", signOutError)
}
```
이걸로 대체 되는 것 같다. 