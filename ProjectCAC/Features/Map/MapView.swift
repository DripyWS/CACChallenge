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
                UserAnnotation()
                ForEach(viewModel.crosswalkWrappeds) { crosswalkWrapped in
                    Annotation(
                        crosswalkWrapped.crosswalk.description,
                        coordinate: crosswalkWrapped.crosswalk.convertedCLLocation
                    ) {
                        Button {
                            viewModel.onTapCrosswalk(of: crosswalkWrapped)
                        } label: {
                            MapPin(crosswalkWrapped: crosswalkWrapped)
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: . realistic))
            
            VStack(spacing: 12) {
                Button {
                    viewModel.onTapOnboarding()
                } label: {
                    Image(systemName: "questionmark")
                        .font(.title2)
                        .foregroundStyle(Color.main)
                        .frame(width: 56, height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(radius: 4)
                        )
                }
                
                Button {
                    viewModel.onTapRegister()
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .frame(width: 56, height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.main)
                                .shadow(radius: 4)
                        )
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 24))
        }
        .onAppear() {
            viewModel.checkLocationAuthorization()
        }
        .task {
            await viewModel.fetchCrosswalks()
        }
        .sheet(item: $viewModel.selectedCrosswalkWrapped) { crosswalkWrapped in
            CrosswalkInfoSheet(
                crosswalkWrapped: crosswalkWrapped,
                onPressed: { viewModel.onTapModifyCrosswalk(of: crosswalkWrapped) }
            )
        }
        .fullScreenCover(isPresented: $viewModel.isPresentedOnboarding) {
            OnboardingView()
        }
        .fullScreenCover(
            isPresented: $viewModel.isPresentedRegister,
            onDismiss: {
                viewModel.onDismissFullScreenCover()
                Task {
                    await viewModel.fetchCrosswalks()
                }
            }
        ) {
            RegisterView(
                location: viewModel.location ?? .init(latitude: 37.7749, longitude: -122.4194),
                crosswalkWrapped: nil
            )
        }
        .fullScreenCover(
            item: $viewModel.selectedModifyCrosswalkWrapped,
            onDismiss: {
                viewModel.onDismissFullScreenCover()
                Task {
                    await viewModel.fetchCrosswalks()
                }
            }
        ) { crosswalkWraaped in
            RegisterView(
                location: crosswalkWraaped.crosswalk.convertedCLLocation,
                crosswalkWrapped: crosswalkWraaped
            )
        }
    }
}

#Preview {
    MapView()
}
