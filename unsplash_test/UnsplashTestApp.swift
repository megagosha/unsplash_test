//
//  unsplash_testApp.swift
//  unsplash_test
//
//  Created by George Tevosov on 16.05.2022.
//

import SwiftUI
import CoreData
@main
struct unsplash_testApp: App {
    @State private var showAlert = false
    @State private var alertData = AlertData.empty
    
    private var dataController = DataController.shared
    //    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .onReceive(NotificationCenter.default.publisher(for: .showAlert)) { notif in
                    if let data = notif.object as? AlertData {
                        alertData = data
                        showAlert = true
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: alertData.title,
                          message: alertData.message,
                          dismissButton: alertData.dismissButton)
                }
        }
    }
}

