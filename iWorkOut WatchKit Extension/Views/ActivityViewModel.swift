import Foundation
import CoreData

extension ActivityView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {

        // MARK: - Properties

        let dataController: DataController
        let dataManager: DataManager
        let exercise: Exercise
        let fetchedRecord: Record?

        // MARK: - Custom init

        init(dataController: DataController, dataManager: DataManager, exercise: Exercise, fetchedRecord: Record?) {
            self.dataController = dataController
            self.dataManager = dataManager
            self.exercise = exercise
            self.fetchedRecord = fetchedRecord
        }

        // MARK: - functions

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
            fetchedRecord?.set1 = Int64(record[1]!)
            fetchedRecord?.set2 = Int64(record[2]!)
            fetchedRecord?.set3 = Int64(record[3]!)
            fetchedRecord?.calories = Int64(dataManager.totalEnergyBurned)
            print("preparing update your record")
            dataController.save()
        }

    }
}
