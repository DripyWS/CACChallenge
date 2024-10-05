//
//  RegisterView.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/22/24.
//

import SwiftUI
import MapKit

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: RegisterViewModel
    
    init(
        location: CLLocationCoordinate2D,
        crosswalkWrapped: CrosswalkWrapped?
    ) {
        self.viewModel = RegisterViewModel(
            location: location,
            crosswalkWrapped: crosswalkWrapped
        )
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("location")
                            .font(.caption)
                            .foregroundStyle(Color.secondaryFont)
                        Map {
                            Marker("Location", coordinate: viewModel.location)
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Photo")
                            .font(.caption)
                            .foregroundStyle(Color.secondaryFont)
                        Button {
                            viewModel.onTapCamera()
                        } label: {
                            if let image = viewModel.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.secondaryBackground)
                                    .frame(height: 200)
                                    .overlay {
                                        Text("Take Picture")
                                            .font(.caption)
                                            .foregroundStyle(Color.secondaryFont)
                                    }
                            }
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Text("Has Voice Traffic Light?")
                            .font(.caption)
                            .foregroundStyle(Color.secondaryFont)
                        Toggle("", isOn: $viewModel.hasLight)
                    }
                    HStack {
                        Text("Has Yellow Block?")
                            .font(.caption)
                            .foregroundStyle(Color.secondaryFont)
                        Toggle("", isOn: $viewModel.hasYellowBlock)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.secondaryBackground.opacity(0.3))
                )
                .padding(.top, 36)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Place Description")
                        .font(.caption)
                        .foregroundStyle(Color.secondaryFont)
                    TextField(
                        "",
                        text: $viewModel.description,
                        prompt: Text("more information of crosswalk")
                            .foregroundStyle(Color.secondaryFont)
                    )
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.secondaryBackground)
                    )
                }
                .padding(.top, 36)
                
                Spacer()
                
                Button {
                    Task {
                        await viewModel.addCrosswalk()
                        dismiss()
                    }
                } label: {
                    Text("Register")
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
            .navigationTitle("Register New Crosswalk")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: NavigationData.self) { data in
                switch data.destination {
                case .camera:
                    CameraView(path: $viewModel.path)
                case .confirm:
                    ConfirmPictureView(
                        path: $viewModel.path,
                        capturedImage: data.image!,
                        selectedImage: $viewModel.image
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundStyle(Color.black)
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterView(
        location: .init(latitude: 37.7749, longitude: -122.4194),
        crosswalkWrapped: nil
    )
}
