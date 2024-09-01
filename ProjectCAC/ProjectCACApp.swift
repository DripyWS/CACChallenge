//
//  ProjectCACApp.swift
//  ProjectCAC
//
//  Created by Chris Yoo on 8/28/24.
//

import SwiftUI
import FirebaseCore
import GoogleMaps
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        
        return true
    }
}

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
