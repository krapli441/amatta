//
//  amattaApp.swift
//  amatta
//
//  Created by 박준형 on 12/13/23.
//

import SwiftUI
import SwiftData
import CoreData

@main
struct amattaApp: App {
    let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: "AlarmData")

           let description = NSPersistentStoreDescription()
           description.shouldMigrateStoreAutomatically = true
           description.shouldInferMappingModelAutomatically = true

           persistentContainer.persistentStoreDescriptions = [description]

           persistentContainer.loadPersistentStores { storeDescription, error in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           }

        // CoreData 모델 검증 코드
        let entities = persistentContainer.managedObjectModel.entities
        for entity in entities {
            print("Entity name: \(entity.name ?? "Unknown")")
            // 추가적인 검증 로직을 여기에 구현할 수 있습니다.
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}

