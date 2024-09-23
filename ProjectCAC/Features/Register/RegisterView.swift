//
//  RegisterView.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/22/24.
//

import SwiftUI
import MapKit

struct RegisterView: View {
    @Binding private var isPresented: Bool
    
    @State private var viewModel = RegisterViewModel()
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack {
                // TODO: 현재 위치 맵
                TextField("", text: $viewModel.description)
                Button {
                    viewModel.onTapCamera()
                } label: {
                    Text(viewModel.image != nil ? "Picture Already Taken" : "Take Picture")
                }
                Spacer()
                Button {
                    // TODO: 있으면 처리
                    isPresented = false
                } label: {
                    Text("Add")
                }
            }
            .navigationTitle("Add")
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .camera:
                    Text("CameraView")
                }
            }
        }
    }
}

#Preview {
    RegisterView(isPresented: .constant(true))
}
