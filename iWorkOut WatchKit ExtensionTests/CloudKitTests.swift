import XCTest
import CoreData
import CloudKit
import SwiftUI
@testable import iWorkOut_WatchKit_Extension

class CloudKitTests: CKSetup {

    func testLoadSample() throws {
        dataController.createSample()
        let results = try dataController.loadExercise(id: "0-0-0")
        XCTAssertEqual(results.count, 1)
    }

    func testDeleteSample() throws {
        try dataController.delete(id: "0-0-0")
        let results = try dataController.loadExercise(id: "0-0-0")
        XCTAssertTrue(results.isEmpty)
    }

    func testUniqueID() throws {
        let results = try Exercise.loadAll()
        let listOfIDs = results.map { $0.id }
        let uniqueIds = listOfIDs.uniqued()
        for id in uniqueIds {
            let results = try dataController.loadExercise(id: id)
            XCTAssertLessThan(results.count, 2)
        }
    }

}
