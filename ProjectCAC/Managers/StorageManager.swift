//
//  StorageManager.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/23/24.
//

import UIKit
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage()
    
    private init() {}
    
    func requestImageByID(id: String) async -> UIImage? {
        let pathRef = storage.reference(withPath: "images/\(id).jpeg")
        
        do {
            let data = try await getData(ref: pathRef)
            return UIImage(data: data)
        } catch {
            print("Error getting image data - \(error)")
            return nil
        }
    }
    
    func requestUploadImage(id: String?, uiImage: UIImage) async -> String? {
        let imageID = id != nil ? id! : UUID().uuidString
        guard let imageData = uiImage.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        let pathRef = storage.reference(withPath: "images/\(imageID).jpeg")
        
        do {
            _ = try await uploadData(ref: pathRef, data: imageData)
        } catch {
            print("Error upload image data - \(error)")
            return nil
        }
        
        return imageID
    }
    
    private func getData(ref: StorageReference) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: data!)
                }
            }
        }
    }
    
    private func uploadData(ref: StorageReference, data: Data) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            ref.putData(data, metadata: metadata) { metadata, error in
                if let error {
                    continuation.resume(throwing: NSError(domain: "Firebase Storage Error", code: 0))
                }
                continuation.resume(returning: true)
            }
        }
    }
}
