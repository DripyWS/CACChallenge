//
//  ConfirmPictureViewModel.swift
//  ProjectCAC
//
//  Created by 정지혁 on 10/5/24.
//

import SwiftUI

@Observable
final class ConfirmPictureViewModel {
    let capturedImage: UIImage
    
    var path: Binding<[NavigationData]>
    var selectedImage: Binding<UIImage?>
    
    init(
        path: Binding<[NavigationData]>,
        capturedImage: UIImage,
        selectedImage: Binding<UIImage?>
    ) {
        self.path = path
        self.capturedImage = capturedImage
        self.selectedImage = selectedImage
    }
    
    func retakePressed() {
        path.wrappedValue.removeLast()
    }
    
    func confirmPressed() {
        selectedImage.wrappedValue = capturedImage
        path.wrappedValue.removeAll()
    }
}
