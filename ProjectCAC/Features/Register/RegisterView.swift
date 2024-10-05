//
//  RegisterView.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/22/24.
//

import SwiftUI
import MapKit

struct RegisterView: View {
    @Binding private var isPresented: Bool
    
    @State private var viewModel: RegisterViewModel
    
    init(
        isPresented: Binding<Bool>,
        location: CLLocationCoordinate2D,
        crosswalkWrapped: CrosswalkWrapped?
    ) {
        self._isPresented = isPresented
        self.viewModel = RegisterViewModel(
            location: location,
            crosswalkWrapped: crosswalkWrapped
        )
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack(spacing: 0) {
                Map {
                    Marker("Location", coordinate: viewModel.location)
                }
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Photo")
                        .font(.caption)
                        .foregroundStyle(Color.secondaryFont)
                    Button {
                        viewModel.onTapCamera()
                    } label: {
                        HStack {
                            Text(viewModel.image != nil ? "Picture Already Taken" : "Take Picture")
                            Spacer()
                            if let image = viewModel.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                }
                .padding(.top, 36)
                
                HStack {
                    Text("Has Voice Traffic Light?")
                        .font(.caption)
                        .foregroundStyle(Color.secondaryFont)
                    Toggle("", isOn: $viewModel.hasLight)
                }
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
                        isPresented = false
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
                .disabled(viewModel.image == nil)
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
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.black)
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterView(
        isPresented: .constant(true),
        location: .init(latitude: 37.7749, longitude: -122.4194),
        crosswalkWrapped: nil
    )
}
