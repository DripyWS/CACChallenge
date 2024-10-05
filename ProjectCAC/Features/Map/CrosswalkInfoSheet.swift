//
//  CrosswalkInfoSheet.swift
//  ProjectCAC
//
//  Created by 정지혁 on 10/5/24.
//

import SwiftUI

struct CrosswalkInfoSheet: View {
    private let crosswalkWrapped: CrosswalkWrapped
    private let onPressed: () -> Void
    
    init(crosswalkWrapped: CrosswalkWrapped, onPressed: @escaping () -> Void) {
        self.crosswalkWrapped = crosswalkWrapped
        self.onPressed = onPressed
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let image = crosswalkWrapped.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 360, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.secondaryBackground)
                    )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondaryBackground)
                    .frame(height: 360)
            }
            
            HStack(spacing: 8) {
                Text("Voice Traffic Ligh")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                crosswalkWrapped.crosswalk.hasLight ?
                                    Color.main.opacity(0.3) :
                                    Color.red.opacity(0.3)
                            )
                    )
                Text("Yellow Block")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                crosswalkWrapped.crosswalk.hasYellowBlock ?
                                    Color.main.opacity(0.3) :
                                    Color.red.opacity(0.3)
                            )
                    )
            }
            
            Text(crosswalkWrapped.crosswalk.description)
            
            HStack(spacing: 4) {
                Text("modified at: ")
                Text(crosswalkWrapped.crosswalk.displayTimestamp)
            }
            .font(.caption)
            .foregroundStyle(Color.secondaryFont)
            .padding(.bottom, 8)
            
            Spacer()
            
            Button {
                onPressed()
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
}
