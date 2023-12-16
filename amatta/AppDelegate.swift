//
//  AppDelegate.swift
//  amatta
//
//  Created by 박준형 on 12/14/23.
//

import Foundation
import UIKit
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // CoreData 초기화 코드
        self.persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // CoreData 모델 검증 코드
        let persistentContainer = self.persistentContainer
        let managedObjectModel = persistentContainer.managedObjectModel
        let entities = managedObjectModel.entities

        for entity in entities {
            print("Entity name: \(entity.name ?? "Unknown")")
            // 여기에서 추가적인 검증 로직을 구현할 수 있습니다.
        }
        
        return true
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AlarmData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

