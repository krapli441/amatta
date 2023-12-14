//
//  amattaApp.swift
//  amatta
//
//  Created by 박준형 on 12/13/23.
//

import SwiftUI
import SwiftData

@main
struct amattaApp: App {
//    var sharedModelContainer: ModelContainer = {
////        let schema = Schema([
////            Item.self,
////        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
//        .modelContainer(sharedModelContainer)
    }
}
