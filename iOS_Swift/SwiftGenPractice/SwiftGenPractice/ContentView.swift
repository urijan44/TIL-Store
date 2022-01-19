//
//  ContentView.swift
//  SwiftGenPractice
//
//  Created by hoseung Lee on 2022/01/20.
//

import SwiftUI
import UIKit

struct ContentView: View {
  var body: some View {
    Text("Hello, world!")
      .padding()
//      .foregroundColor(Colors.customRed.color)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

extension View {
  func foregroundColor(_ uicolor: UIColor) -> some View {
    self.foregroundColor(Color(uicolor))
  }
}
