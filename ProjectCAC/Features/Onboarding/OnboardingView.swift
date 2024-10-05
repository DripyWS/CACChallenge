//
//  OnboardingView.swift
//  ProjectCAC
//
//  Created by 정지혁 on 10/5/24.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundStyle(Color.black)
                    }
                }
                
                // 자기소개나 앱 의도를 넣어주시면 됩니다
                VStack(alignment: .leading, spacing: 8) {
                    Text("About Me")
                        .font(.title)
                        .padding(.bottom, 12)
                    Text("Hello ...")
                }
                
                Divider()
                
                // 중간에 스크린샷이나 이해할 수 있는 이미지를 넣어주시면 됩니다
                VStack(alignment: .leading, spacing: 8) {
                    Text("How to use")
                        .font(.title)
                        .padding(.bottom, 12)
                    Text("1. Press Add Button")
                        .font(.title3)
                    Text("...")
                    
                    Text("2. Enter Information of Crosswalk")
                        .font(.title3)
                    Text("...")
                    
                    Text("3. Press Register Button")
                        .font(.title3)
                    Text("...")
                }
            }
            .padding(24)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    OnboardingView()
}
