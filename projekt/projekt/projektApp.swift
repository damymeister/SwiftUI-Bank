//
//  projektApp.swift
//  projekt
//
//  Created by student on 20/06/2023.
//

import SwiftUI

@main
struct projektApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
