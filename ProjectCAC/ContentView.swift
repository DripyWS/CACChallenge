//
//  ContentView.swift
//  ProjectCAC
//
//  Created by Chris Yoo on 8/28/24.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @State private var viewModel = ContentViewModel()
    
    var body: some View {
        Map(position: $viewModel.position)
            .mapStyle(.standard)
            .mapStyle(.standard(elevation: . realistic))
            .onAppear() {
                viewModel.checkIfLocationServicesIsEnabled()
            }
    }
}


#Preview {
    ContentView()
}


final class ContentViewModel: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var position: MapCameraPosition = .automatic
    
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
}
