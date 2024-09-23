//
//  MapViewModel.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/22/24.
//

import SwiftUI
import MapKit

@Observable
final class MapViewModel: NSObject {
    var isPresentedRegister = false
    var position: MapCameraPosition = .userLocation(fallback: .automatic)
    var location: CLLocationCoordinate2D?
    
    var crosswalks: [Crosswalk] = []
    var images: [UIImage?] = []

    @ObservationIgnored var locationManager = CLLocationManager()
    
    func onTapRegister() {
        isPresentedRegister = true
    }
    
    func fetchCrosswalks() async {
        let crosswalks = await FirestoreManager.shared.requestCrosswalks()
        _ = crosswalks.map {
            self.images.append(nil)
            self.crosswalks.append($0);
        }
        
        for index in crosswalks.indices {
            let image = await StorageManager.shared.requestImageByID(id: crosswalks[index].image)
            images[index] = image
        }
    }
    
    func checkLocationAuthorization() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location restricted")
        case .denied:
            print("Location denied")
        case .authorizedAlways:
            print("Location authorizedAlways")
        case .authorizedWhenInUse:
            print("Location authorized when in use")
            self.location = locationManager.location?.coordinate
        @unknown default:
            print("Location service disabled")
        }
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first?.coordinate
    }
}
