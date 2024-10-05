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
    var path: Binding<[NavigationData]>
    var image: UIImage?
    
    let preview: CameraPreviewView
    let output = AVCapturePhotoOutput()
    
    init(path: Binding<[NavigationData]>) {
        self._path = path
        self.preview = CameraPreviewView(cameraPosition: .back, output: output)
    }
    
    func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        output.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func savePhoto(_ imageData: Data) {
        guard let image = UIImage(data: imageData) else { return }
        self.image = image
        path.wrappedValue.append(NavigationData(destination: .confirm, image: image))
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
