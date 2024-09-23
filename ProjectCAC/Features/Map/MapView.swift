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
        ZStack(alignment: .bottomTrailing) {
            Map(position: $viewModel.position) {
                Marker("???", coordinate: .init(latitude: 37.7749, longitude: -122.4194))
            }
            .mapStyle(.standard(elevation: . realistic))
            Button {
                viewModel.onTapRegister()
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(Color.white)
                    .font(.title)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.main)
                    )
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 32))
        }
        .onAppear() {
            viewModel.checkLocationAuthorization()
        }
        .fullScreenCover(isPresented: $viewModel.isPresentedRegister) {
            RegisterView(
                isPresented: $viewModel.isPresentedRegister,
                location: viewModel.location ?? .init(latitude: 37.7749, longitude: -122.4194)
            )
        }
    }
}

#Preview {
    MapView()
}
