//
//  psychoheads.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/12/25.
//

import SwiftUI
import FirebaseCore

// App Delegate to control orientations
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone: Portrait only
            return .portrait
        } else {
            // iPad: All orientations
            return .all
        }
    }
}

@main
struct psychoheadsApp: App {
    
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // initialized Firebase database
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(SourceModel())
        }
    }
}
