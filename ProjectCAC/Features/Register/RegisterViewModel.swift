//
//  RegisterViewModel.swift
//  ProjectCAC
//
//  Created by 정지혁 on 9/22/24.
//

import UIKit

enum NavigationDestination {
    case camera
}

@Observable
final class RegisterViewModel {
    var path: [NavigationDestination] = []
    var description = ""
    var image: UIImage?
    
    func onTapCamera() {
        path.append(.camera)
    }
}
