//
//  AlarmViewModel.swift
//  amatta
//
//  Created by 박준형 on 12/26/23.
//

import Foundation
import CoreData

class AlarmDataModel: ObservableObject {
    @Published var alarms: [Alarm] = []
    
    private var managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        fetchAlarms()
    }

    func fetchAlarms() {
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        do {
            alarms = try managedObjectContext.fetch(fetchRequest)
        } catch {
            print("Error fetching alarms: \(error)")
        }
    }

    // 여기에 다른 CRUD 작업을 위한 메소드를 추가할 수 있음
}
