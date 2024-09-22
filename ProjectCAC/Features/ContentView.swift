//
//  CententView.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/22/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true

    var body: some View {
        if isLoading {
            SplashView(isLoading: $isLoading)
        } else {
            MapView()
        }
    }
}

#Preview {
    ContentView()
}
