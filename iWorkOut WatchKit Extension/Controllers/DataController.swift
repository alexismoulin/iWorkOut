import CoreData

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Could not retrieve a persistent store description.")
        }
        print("OK - \(description.description)")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            } else {
                print("Store description: \(storeDescription)")
            }
        }
    }
    
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Cannot save data: \(error.localizedDescription)")
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func createSamples() {
        let newRecord = Record(context: container.viewContext)
        newRecord.id = "0-0-0"
        newRecord.value = 3
        save()
        print("sample successfully created")
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Record.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? container.viewContext.execute(batchDeleteRequest)
    }
}
