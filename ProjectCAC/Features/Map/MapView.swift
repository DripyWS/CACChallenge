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
                            VStack(spacing: 0) {
                                if let image = crosswalkWrapped.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 40, height: 40)
                                } else {
                                    Circle()
                                        .fill(Color.secondaryBackground)
                                        .frame(width: 40, height: 40)
                                }
                            }
                            .padding(4)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .shadow(
                                        color: crosswalkWrapped.crosswalk.hasLight ? Color.main : Color.red,
                                        radius: 8
                                    )
                            )
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: . realistic))
            
            Button {
                viewModel.onTapRegister()
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundStyle(Color.white)
                    .padding(16)
                    .background(
                        Circle()
                            .fill(Color.main)
                            .shadow(radius: 8)
                    )
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 24))
        }
        .onAppear() {
            viewModel.checkLocationAuthorization()
        }
        .task {
            await viewModel.fetchCrosswalks()
            print("Task Finished")
        }
        .sheet(item: $viewModel.selectedCrosswalkWrapped) { crosswalkWrapped in
            VStack(alignment: .leading, spacing: 8) {
                Text(crosswalkWrapped.crosswalk.description)
                    .font(.title2)
                Text(crosswalkWrapped.crosswalk.displayTimestamp)
                    .font(.caption)
                    .foregroundStyle(Color.secondaryFont)
                    .padding(.bottom, 8)
                if let image = crosswalkWrapped.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.secondaryBackground)
                        .frame(height: 400)
                }
                Spacer()
                Button {
                    viewModel.onTapModifyCrosswalk(of: crosswalkWrapped)
                } label: {
                    Text("Modify")
                        .foregroundStyle(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.main)
                        )
                }
            }
            .padding(24)
            .presentationDetents([.height(600)])
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
                isPresented: $viewModel.isPresentedRegister,
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
                isPresented: Binding(
                    get: { viewModel.selectedModifyCrosswalkWrapped != nil },
                    set: { _ in viewModel.selectedModifyCrosswalkWrapped = nil }
                ),
                location: crosswalkWraaped.crosswalk.convertedCLLocation,
                crosswalkWrapped: crosswalkWraaped
            )
        }
    }
}

#Preview {
    MapView()
}
