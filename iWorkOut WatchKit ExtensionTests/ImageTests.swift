import XCTest
import UIKit
@testable import iWorkOut_WatchKit_Extension

class ImageTests: XCTestCase {

    func testLaodImages() throws {
        let results = try Exercise.loadAll()
        let listOfIDsWithoutDuration = results
            .filter { $0.type != ExerciseType.duration.rawValue }
            .map { $0.id }
        let listOfIDsWithDuration = results
            .filter { $0.type == ExerciseType.duration.rawValue }
            .map { $0.id }

        for id in listOfIDsWithoutDuration {
            XCTAssertNotNil(UIImage(named: "\(id)-a"), "\(id)-a")
            XCTAssertNotNil(UIImage(named: "\(id)-b"), "\(id)-b")
        }

        for id in listOfIDsWithDuration {
            XCTAssertNotNil(UIImage(named: id), id)
        }
    }

    func testImageSizes() throws {
        let results = try Exercise.loadAll()
        let listOfIDsWithoutDuration = results
            .filter { $0.type != ExerciseType.duration.rawValue }
            .map { $0.id }
        let listOfIDsWithDuration = results
            .filter { $0.type == ExerciseType.duration.rawValue }
            .map { $0.id }

        for id in listOfIDsWithoutDuration {
            XCTAssertEqual(UIImage(named: "\(id)-a")?.size, CGSize(width: 256, height: 165), "\(id)-a")
            XCTAssertEqual(UIImage(named: "\(id)-b")?.size, CGSize(width: 256, height: 165), "\(id)-b")
        }

        for id in listOfIDsWithDuration {
            XCTAssertEqual(UIImage(named: id)?.size, CGSize(width: 256, height: 165), id)
        }
    }
}
