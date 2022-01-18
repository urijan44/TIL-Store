//
//  MainView.swift
//  FirebasePhoneAuthPractice
//
//  Created by hoseung Lee on 2022/01/17.
//

import SwiftUI

struct MainView: View {
  @State var username: String!
  var body: some View {
    Text("Hello, \(username)")
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
