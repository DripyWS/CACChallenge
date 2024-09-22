//
//  MapViewModel.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/22/24.
//

import SwiftUI
import MapKit

final class MapViewModel: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("Please Update Your Location Services Settings")
        }
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your Location Is Restricted Likely Due to Parental Control")
        case .denied:
            print("You Have Deleted The App Location Setting. Go Into Settings To Turn It On")
        case .authorizedWhenInUse:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
            
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
}
