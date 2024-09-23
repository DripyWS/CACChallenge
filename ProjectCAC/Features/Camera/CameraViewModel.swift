//
//  CameraViewModel.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/23/24.
//

import AVFoundation
import UIKit
import SwiftUI

@Observable
final class CameraViewModel: NSObject {
    var path: Binding<[NavigationDestination]>
    var image: Binding<UIImage?>
    
    let preview: CameraPreviewView
    let output = AVCapturePhotoOutput()
    
    init(path: Binding<[NavigationDestination]>, image: Binding<UIImage?>) {
        self._path = path
        self._image = image
        self.preview = CameraPreviewView(cameraPosition: .back, output: output)
    }
    
    func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        output.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func savePhoto(_ imageData: Data) {
        guard let image = UIImage(data: imageData) else { return }
        self.image.wrappedValue = image
        self.path.wrappedValue.removeAll()
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {}
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {}
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {}
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        self.savePhoto(imageData)
    }
}
