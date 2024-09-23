//
//  FirestoreManager.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/23/24.
//

import Foundation
import FirebaseFirestore

final class FirestoreManager {
    static let shared = FirestoreManager()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    func requestCrosswalks() async -> [Crosswalk] {
        var result: [Crosswalk] = []
        
        do {
            let querySnapshot = try await db.collection("Crosswalk").getDocuments()
            
            for document in querySnapshot.documents {
                let crosswalk = try document.data(as: Crosswalk.self)
                result.append(crosswalk)
            }
        } catch {
            print("Error getting documents: \(error)")
        }
        print(result)
        
        return result
    }
    
    func requestAddCrosswalk(of crosswalk: Crosswalk) {
        do {
            try db.collection("Crosswalk").addDocument(from: crosswalk)
        } catch {
            print("Error adding document: \(error)")
        }
    }
}
