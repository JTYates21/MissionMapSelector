//
//  MissionMapSelectorApp.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 8/22/22.
//

import FirebaseCore
import FirebaseFirestore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
      FirebaseApp.configure()
      
      _ = Firestore.firestore()

    return true
  }
}


@main
struct YourApp: App {
  /// register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      MainContainerView()
    }
  }
}
