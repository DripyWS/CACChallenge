//
//  CameraView.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/23/24.
//

import SwiftUI

struct CameraView: View {
    @State private var viewModel: CameraViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    init(path: Binding<[NavigationDestination]>, image: Binding<UIImage?>) {
        self.viewModel = CameraViewModel(path: path, image: image)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            viewModel.preview
                .onAppear {
                    viewModel.preview.requestCameraPermission()
                }
            HStack {
                Button {
                    viewModel.capturePhoto()
                } label: {
                    Circle()
                        .frame(width: 60, height: 60)
                        .overlay {
                            Circle()
                                .strokeBorder(style: .init(lineWidth: 2))
                                .foregroundStyle(Color.white)
                                .padding(4)
                        }
                }
            }
            .padding(.horizontal, 24)
            .frame(height: 100)
        }
        .navigationTitle("Camera")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
        }
    }
}

#Preview {
    CameraView(path: .constant([]), image: .constant(nil))
}
