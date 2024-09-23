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
                ForEach(viewModel.crosswalks.indices, id: \.self) { index in
                    Annotation(
                        viewModel.crosswalks[index].description,
                        coordinate: viewModel.crosswalks[index].convertedCLLocation
                    ) {
                        VStack(spacing: 0) {
                            if let image = viewModel.images[index] {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue)
                                    .frame(width: 40, height: 40)
                            }
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(viewModel.crosswalks[index].hasLight ? Color.green : Color.red)
                        )
                    }
                }
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
        .task {
            await viewModel.fetchCrosswalks()
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
