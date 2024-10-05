//
//  MapPin.swift
//  ProjectCAC
//
//  Created by 정지혁 on 10/5/24.
//

import SwiftUI

struct MapPin: View {
    private let crosswalkWrapped: CrosswalkWrapped
    
    init(crosswalkWrapped: CrosswalkWrapped) {
        self.crosswalkWrapped = crosswalkWrapped
    }
    
    var body: some View {
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
                    color: (crosswalkWrapped.crosswalk.hasLight && crosswalkWrapped.crosswalk.hasYellowBlock) ? Color.main : Color.red,
                    radius: 8
                )
        )
    }
}
