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
    
    var path: [NavigationDestination] = []
    var description = ""
    var image: UIImage?
    var hasLight = false
    
    init(location: CLLocationCoordinate2D) {
        self.location = location
    }
    
    func onTapCamera() {
        path.append(.camera)
    }
    
    func addCrosswalk() {
        let crosswalk = Crosswalk(
            description: description,
            hasLight: hasLight,
            image: "2",
            timestamp: Date(),
            location: .init(latitude: location.latitude, longitude: location.longitude)
        )
        FirestoreManager.shared.requestAddCrosswalk(of: crosswalk)
    }
}
