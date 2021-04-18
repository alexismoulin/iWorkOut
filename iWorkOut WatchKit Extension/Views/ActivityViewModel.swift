import Foundation
import CoreData

extension ActivityView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {

        // MARK: - Properties

        let dataController: DataController
        let dataManager: DataManager
        let exercise: Exercise
        private let recordController: NSFetchedResultsController<Record>
        @Published var records: [Record] = []

        var CDRecord: Record? {
            recordController.fetchedObjects?.first(where: {$0.id == exercise.id})
        }

        // MARK: - Custom init

        init(dataController: DataController, dataManager: DataManager, exercise: Exercise) {
            self.dataController = dataController
            self.dataManager = dataManager
            self.exercise = exercise
            let request: NSFetchRequest<Record> = Record.fetchRequest()
            recordController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            super.init()
            recordController.delegate = self

            do {
                try recordController.performFetch()
                records = recordController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch our projects: \(error.localizedDescription)")
            }
        }

        // MARK: - fucntions

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newRecords = controller.fetchedObjects as? [Record] {
                records = newRecords
            }
        }

        func createNewRecord(record: [Int: Int]) {
            let newRecord = Record(context: dataController.container.viewContext)
            newRecord.id = exercise.id
            newRecord.set1 = Int64(record[1]!)
            newRecord.set2 = Int64(record[2]!)
            newRecord.set3 = Int64(record[3]!)
            newRecord.calories = Int64(dataManager.totalEnergyBurned)
            print("saving new record")
            dataController.save()
        }

        func updateExistingRecord(record: [Int: Int]) {
            CDRecord?.set1 = Int64(record[1]!)
            CDRecord?.set2 = Int64(record[2]!)
            CDRecord?.set3 = Int64(record[3]!)
            CDRecord?.calories = Int64(dataManager.totalEnergyBurned)
            print("preparing update your record")
            dataController.save()
        }

    }
}
