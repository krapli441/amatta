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
        // 여기에서 CoreData 모델 파일 이름을 프로젝트에 맞게 수정하세요.
        persistentContainer = NSPersistentContainer(name: "AlarmData")

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
                // managedObjectContext를 ContentView에 전달합니다.
                .environment(\.managedObjectContext, persistentContainer.viewContext)
//                .onOpenURL { url in
//                                    if let alarmIdentifier = extractAlarmIdentifier(from: url) {
//                                        // CoreData에서 해당 alarmIdentifier로 알람 정보 조회
//                                        // 조회된 정보를 가지고 PushAlarmScreenView로 이동
//                                        // 예: PushAlarmScreenView(alarmIdentifier: alarmIdentifier)
//                                    }
//                                }
        }
    }
}

