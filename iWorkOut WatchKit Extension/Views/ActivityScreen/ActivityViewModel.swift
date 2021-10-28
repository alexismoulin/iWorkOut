import Foundation
import CoreData

class ActivityViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {

    // MARK: - Properties

    enum ScreenType {
        case health, recover, setInfo, summary
    }

    let dataController: DataController
    let dataManager: DataManager
    let exercise: Exercise
    let fetchedRecord: Record?

    @Published var record: [Int: Int] = [1: 0, 2: 0, 3: 0]
    @Published var setNumber: Int = 1
    @Published var title: String = "Get Ready!"
    @Published var timeRemaining: Int = 3
    @Published var percent: Double = 0
    @Published var value: Double = 0
    @Published var screenType: ScreenType = .recover

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
        newRecord.heartRate = Int64(
            dataManager.heartRateValues.reduce(0, +) / Double(dataManager.heartRateValues.count)
        )
        print("saving new record")
        dataController.save()
    }

    func updateExistingRecord(record: [Int: Int]) {
        fetchedRecord?.set1 = Int64(record[1]!)
        fetchedRecord?.set2 = Int64(record[2]!)
        fetchedRecord?.set3 = Int64(record[3]!)
        fetchedRecord?.calories = Int64(dataManager.totalEnergyBurned)
        fetchedRecord?.heartRate = Int64(
            dataManager.heartRateValues.reduce(0, +) / Double(dataManager.heartRateValues.count)
        )
        print("preparing update your record")
        dataController.save()
    }

}
