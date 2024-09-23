//
//  RegisterViewModel.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/22/24.
//

import UIKit
import MapKit

enum NavigationDestination {
    case camera
}

@Observable
final class RegisterViewModel {
    let location: CLLocationCoordinate2D
    let crosswalkWrapped: CrosswalkWrapped?
    
    var path: [NavigationDestination] = []
    var description = ""
    var image: UIImage?
    var hasLight = false
    
    init(
        location: CLLocationCoordinate2D,
        crosswalkWrapped: CrosswalkWrapped?
    ) {
        self.location = location
        self.crosswalkWrapped = crosswalkWrapped
        self.description = crosswalkWrapped?.crosswalk.description ?? ""
        self.image = crosswalkWrapped?.image
        self.hasLight = crosswalkWrapped?.crosswalk.hasLight ?? false
    }
    
    func onTapCamera() {
        path.append(.camera)
    }
    
    func addCrosswalk() async {
        if let crosswalk = crosswalkWrapped?.crosswalk, let image = image {
            let imageID = await StorageManager.shared.requestUploadImage(id: crosswalk.image, uiImage: image)
            
            if let imageID {
                let newCrosswalk = Crosswalk(
                    id: crosswalk.id,
                    description: description,
                    hasLight: hasLight,
                    image: imageID,
                    timestamp: Date(),
                    location: crosswalk.location
                )
                FirestoreManager.shared.requestAddCrosswalk(of: newCrosswalk)
            }
        } else if let image = image {
            let imageID = await StorageManager.shared.requestUploadImage(id: nil, uiImage: image)
            
            if let imageID {
                let crosswalk = Crosswalk(
                    description: description,
                    hasLight: hasLight,
                    image: imageID,
                    timestamp: Date(),
                    location: .init(latitude: location.latitude, longitude: location.longitude)
                )
                FirestoreManager.shared.requestAddCrosswalk(of: crosswalk)
            }
        }
    }
}
