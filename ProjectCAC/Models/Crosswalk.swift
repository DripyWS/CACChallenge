//
//  Crosswalk.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/23/24.
//

import Foundation
import FirebaseFirestore
import MapKit

struct Crosswalk: Identifiable, Codable {
    @DocumentID var id: String?
    var description: String
    var hasLight: Bool
    var image: String
    var timestamp: Date
    var location: GeoPoint

    var convertedCLLocation: CLLocationCoordinate2D {
        return .init(latitude: location.latitude, longitude: location.longitude)
    }
}
