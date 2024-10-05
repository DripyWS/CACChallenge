//
//  ConfirmPictureView.swift
//  ProjectCAC
//
//  Created by 정지혁 on 10/5/24.
//

import SwiftUI

struct ConfirmPictureView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: ConfirmPictureViewModel
    
    init(
        path: Binding<[NavigationData]>,
        capturedImage: UIImage,
        selectedImage: Binding<UIImage?>
    ) {
        viewModel = ConfirmPictureViewModel(
            path: path,
            capturedImage: capturedImage,
            selectedImage: selectedImage
        )
    }
    
    var body: some View {
        VStack {
            Image(uiImage: viewModel.capturedImage)
                .resizable()
                .scaledToFit()
            HStack {
                Button {
                    viewModel.retakePressed()
                } label: {
                    Text("Retake")
                }
                Spacer()
                Button {
                    viewModel.confirmPressed()
                } label: {
                    Text("Confirm")
                }
            }
            .padding(.horizontal, 48)
            .frame(height: 100)
        }
        .navigationTitle("Preview")
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
    ConfirmPictureView(
        path: .constant([]),
        capturedImage: UIImage(),
        selectedImage: .constant(nil)
    )
}
