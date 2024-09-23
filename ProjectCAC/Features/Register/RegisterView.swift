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
            VStack(spacing: 0) {
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
                        .foregroundStyle(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.red)
                        )
                }
                .disabled(viewModel.image == nil)
            }
            .padding(24)
            .navigationTitle("Register New Crosswalk")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .camera:
                    CameraView(path: $viewModel.path, image: $viewModel.image)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.black)
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterView(isPresented: .constant(true))
}
