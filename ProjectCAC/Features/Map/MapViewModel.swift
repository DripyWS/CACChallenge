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
    private let locationManager = CLLocationManager()
    
    var isPresentedOnboarding = false
    var isPresentedRegister = false
    var selectedCrosswalkWrapped: CrosswalkWrapped?
    var selectedModifyCrosswalkWrapped: CrosswalkWrapped?
    
    var position: MapCameraPosition = .userLocation(fallback: .automatic)
    var location: CLLocationCoordinate2D?
    var crosswalkWrappeds: [CrosswalkWrapped] = []
    
    func onTapOnboarding() {
        isPresentedOnboarding = true
    }
    
    func onTapRegister() {
        isPresentedRegister = true
    }
    
    func fetchCrosswalks() async {
        let crosswalks = await FirestoreManager.shared.requestCrosswalks()
        
        for crosswalk in crosswalks {
            if let id = crosswalk.image {
                let image = await StorageManager.shared.requestImageByID(id: id)
                crosswalkWrappeds.append(CrosswalkWrapped(crosswalk: crosswalk, image: image))
            } else {
                crosswalkWrappeds.append(CrosswalkWrapped(crosswalk: crosswalk, image: nil))
            }
        }
    }
    
    func onTapCrosswalk(of crosswalkWrapped: CrosswalkWrapped) {
        self.selectedCrosswalkWrapped = crosswalkWrapped
    }
    
    func onTapModifyCrosswalk(of crosswalkWrapped: CrosswalkWrapped) {
        self.selectedCrosswalkWrapped = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.selectedModifyCrosswalkWrapped = crosswalkWrapped
        }
    }
    
    func onDismissFullScreenCover() {
        self.crosswalkWrappeds = []
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
