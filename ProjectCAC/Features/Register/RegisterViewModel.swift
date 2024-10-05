//
//  RegisterViewModel.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/22/24.
//

import MapKit
import SwiftUI
import UIKit

enum NavigationDestination {
    case camera
    case confirm
}

struct NavigationData: Hashable {
    let destination: NavigationDestination
    let image: UIImage?
}

@Observable
final class RegisterViewModel {
    let location: CLLocationCoordinate2D
    let crosswalkWrapped: CrosswalkWrapped?
    
    var path: [NavigationData] = []
    var description = ""
    var image: UIImage?
    var hasLight = false
    var hasYellowBlock = false
    
    init(
        location: CLLocationCoordinate2D,
        crosswalkWrapped: CrosswalkWrapped?
    ) {
        self.location = location
        self.crosswalkWrapped = crosswalkWrapped
        self.description = crosswalkWrapped?.crosswalk.description ?? ""
        self.hasLight = crosswalkWrapped?.crosswalk.hasLight ?? false
    }
    
    func onTapCamera() {
        path.append(NavigationData(destination: .camera, image: nil))
    }
    
    func addCrosswalk() async {
        if let image = image {
            await addCrosswalkWithImage(image: image)
        } else {
            addCrosswalkWithoutImage()
        }
    }
    
    private func addCrosswalkWithoutImage() {
        let new = Crosswalk(
            id: crosswalkWrapped?.crosswalk.id,
            description: description,
            hasLight: hasLight,
            hasYellowBlock: hasYellowBlock,
            image: nil,
            timestamp: Date(),
            location: crosswalkWrapped?.crosswalk.location ?? .init(latitude: location.latitude, longitude: location.longitude)
        )
        FirestoreManager.shared.requestAddCrosswalk(of: new)
    }
    
    private func addCrosswalkWithImage(
        image: UIImage
    ) async {
        let imageID = await StorageManager.shared.requestUploadImage(
            id: crosswalkWrapped?.crosswalk.image,
            uiImage: image
        )
        let new = Crosswalk(
            id: crosswalkWrapped?.crosswalk.id,
            description: description,
            hasLight: hasLight,
            hasYellowBlock: hasYellowBlock,
            image: imageID,
            timestamp: Date(),
            location: crosswalkWrapped?.crosswalk.location ?? .init(latitude: location.latitude, longitude: location.longitude)
        )
        FirestoreManager.shared.requestAddCrosswalk(of: new)
    }
}
