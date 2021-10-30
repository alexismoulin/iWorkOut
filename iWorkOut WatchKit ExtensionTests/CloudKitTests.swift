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

}
