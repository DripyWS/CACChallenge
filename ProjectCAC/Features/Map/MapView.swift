//
//  MapView.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/22/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var viewModel = MapViewModel()
    
    var body: some View {
        Map(position: $viewModel.position) {
            Marker("???", coordinate: .init(latitude: 37.7749, longitude: -122.4194))
        }
        .mapStyle(.standard)
        .mapStyle(.standard(elevation: . realistic))
        .onAppear() {
            viewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

#Preview {
    MapView()
}
