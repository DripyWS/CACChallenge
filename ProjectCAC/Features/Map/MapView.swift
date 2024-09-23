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
        ZStack(alignment: .topTrailing) {
            Map(position: $viewModel.position) {
                Marker("???", coordinate: .init(latitude: 37.7749, longitude: -122.4194))
            }
            .mapStyle(.standard(elevation: . realistic))
            Button {
                viewModel.onTapRegister()
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(Color.black)
                    .font(.title)
            }
            .padding(.trailing)
        }
        .onAppear() {
            viewModel.checkLocationAuthorization()
        }
        .fullScreenCover(isPresented: $viewModel.isPresentedRegister) {
            RegisterView(isPresented: $viewModel.isPresentedRegister)
        }
    }
}

#Preview {
    MapView()
}
