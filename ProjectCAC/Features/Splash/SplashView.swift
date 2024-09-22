//
//  File.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/22/24.
//

import SwiftUI

struct SplashView: View {
    @Binding private var isLoading: Bool
    
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    init(isLoading: Binding<Bool>) {
        self._isLoading = isLoading
    }
    
    var body: some View {
        VStack {
            VStack {
                Image("PencilLine")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 0.9
                    self.opacity = 1.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    SplashView(isLoading: .constant(true))
}
