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
}
