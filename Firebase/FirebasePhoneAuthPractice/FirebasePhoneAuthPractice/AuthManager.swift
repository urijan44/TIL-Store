//
//  AuthManager.swift
//  FirebasePhoneAuthPractice
//
//  Created by hoseung Lee on 2022/01/17.
//

import Foundation
import Firebase

enum APIError: Error {
  case failure
}

class AuthManager {
  static let shared = AuthManager()
  var user: User?
  private init() {
    requestPhoneAuthentication("") { (_, _) in
      
    }
  }
  
  private var authenticationStateHandle: AuthStateDidChangeListenerHandle?
  
  func signIn() {
    if Auth.auth().currentUser == nil {
//      Auth.auth().sign
    }
  }
  
  func requestPhoneAuthentication(_ phone: String, completion: @escaping (Bool, APIError?)->Void) {
    
    if let handle = authenticationStateHandle {
      Auth.auth().removeStateDidChangeListener(handle)
    }
    
    authenticationStateHandle = Auth.auth()
      .addStateDidChangeListener{ _, user in
        self.user = user
      }
    
    
    
    completion(true, nil)
    
  }
}
