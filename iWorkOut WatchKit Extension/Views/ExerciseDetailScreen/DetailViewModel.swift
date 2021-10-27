import Foundation
import CoreData

class DetailViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {

    // MARK: - Properties

    let dataController: DataController
    let dataManager: DataManager
    let exercise: Exercise

    private let recordController: NSFetchedResultsController<Record>
    @Published var fetchedRecord: Record?

    // MARK: - Custom init

    init(dataController: DataController, dataManager: DataManager, exercise: Exercise) {
        self.dataController = dataController
        self.dataManager = dataManager
        self.exercise = exercise
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "id = %@", exercise.id)
        request.fetchLimit = 1
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
            fetchedRecord = recordController.fetchedObjects?.first
        } catch {
            print("Failed to fetch the saved records: \(error.localizedDescription)")
        }
    }

    // MARK: - Functions

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newRecord = controller.fetchedObjects?.first as? Record {
            fetchedRecord = newRecord
        }
    }

}
