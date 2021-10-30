import CoreData
import CloudKit
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
                print("Saved")
            } catch {
                print("Cannot save data: \(error.localizedDescription)")
            }
        }
    }

    /// Count the number of elements (generic) in the Core data stack
    /// - Parameter fetchRequest: Fetch request on a generic type
    /// - Returns: Number of elements
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func delete(id: String) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Record")
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try container.viewContext.execute(batchDeleteRequest)
    }

    func createSample() {
        let newRecord = Record(context: container.viewContext)
        newRecord.id = "0-0-0"
        newRecord.set1 = 3
        newRecord.set2 = 3
        newRecord.set3 = 3
        save()
        print("sample successfully created")
    }

    func loadExercise (id: String) throws -> [Record] {
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        let results = try container.viewContext.fetch(request)
        return results
    }

    /// Deletes all records from Cloudkit
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Record.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? container.viewContext.execute(batchDeleteRequest)
    }
}
