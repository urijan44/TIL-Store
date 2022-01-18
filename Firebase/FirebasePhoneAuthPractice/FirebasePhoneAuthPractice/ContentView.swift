//
//  ContentView.swift
//  FirebasePhoneAuthPractice
//
//  Created by hoseung Lee on 2022/01/17.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
  
  @State var phoneNumber: String = ""
  @State var buttonText: String = "인증요청"
  @State var userVerify: String = ""
  @State var buttonDisabled = false
  @State var watingVeryfiId = false
  @State var verificationId: String?
  @State var showMainView = false
  @State var isVerifying = false
  
  var body: some View {
    
    VStack(spacing: 20) {
      HStack {
        TextField("전화번호를 입력하세요", text: $phoneNumber)
        Button {
          requestVerifyCode()
        } label: {
          Text(buttonText)
        }
        .disabled(buttonDisabled)
      }
      if watingVeryfiId {
        HStack {
          TextField("인증번호를 입력하세요", text: $userVerify)
          Button {
            verifyLogin()
          } label: {
            Text("인증하기")
          }
          .disabled(isVerifying)
        }
      }
    }
    .fullScreenCover(isPresented: $showMainView, onDismiss: {
      
    }, content: {
      MainView(username: phoneNumber)
    })
    .padding()
  }
    
  func verifyLogin() {
    isVerifying = true
    let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId ?? "", verificationCode: userVerify)
    Auth.auth().signIn(with: credential) { (success, error) in
      if let error = error {
        print("error: \(error.localizedDescription)")
        
      } else {
        print("success")
        showMainView = true
      }
      isVerifying = false
    }
  }
  
  func requestVerifyCode() {
    buttonDisabled = true
    let validPhoneNumber = "+82\(phoneNumber)"
    PhoneAuthProvider.provider().verifyPhoneNumber(validPhoneNumber, uiDelegate: nil) { verification, error in
      if let error = error {
        print("error: \(error)")
        buttonDisabled = false
      } else {
        self.verificationId = verification
        withAnimation {
          watingVeryfiId = true
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
