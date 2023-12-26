//
//  AlarmViewModel.swift
//  amatta
//
//  Created by 박준형 on 12/26/23.
//

import Foundation
import CoreData

class AlarmDataModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    @Published var alarms: [Alarm] = []
    
    private var managedObjectContext: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<Alarm>

    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]  // 알람을 정렬하는 방법 지정

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            alarms = fetchedResultsController.fetchedObjects ?? []
        } catch {
            print("Error fetching alarms: \(error)")
        }
    }

    func fetchAlarms() {
        do {
            try fetchedResultsController.performFetch()
            alarms = fetchedResultsController.fetchedObjects ?? []
        } catch {
            print("Error refetching alarms: \(error)")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedAlarms = controller.fetchedObjects as? [Alarm] {
            alarms = fetchedAlarms
        }
    }

    // 여기에 다른 CRUD 작업을 위한 메소드를 추가할 수 있음
}


