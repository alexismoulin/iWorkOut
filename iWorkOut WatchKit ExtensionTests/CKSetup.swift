import XCTest
import CoreData
import CloudKit
@testable import iWorkOut_WatchKit_Extension

class CKSetup: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController()
        managedObjectContext = dataController.container.viewContext
    }

}
