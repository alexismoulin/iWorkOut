import XCTest
import UIKit
@testable import iWorkOut_WatchKit_Extension

class ImageTests: XCTestCase {

    func testLaodImages() throws {
        let results = try Exercise.loadAll()
        let listOfIDs = results.map { $0.id }
        for id in listOfIDs {
            XCTAssertNotNil(UIImage(named: "\(id)-a"))
            XCTAssertNotNil(UIImage(named: "\(id)-b"))
        }
    }

    func testImageSizes() throws {
        let results = try Exercise.loadAll()
        let listOfIDs = results.map { $0.id }
        for id in listOfIDs {
            XCTAssertEqual(UIImage(named: "\(id)-a")?.size, CGSize(width: 256, height: 165))
            XCTAssertEqual(UIImage(named: "\(id)-b")?.size, CGSize(width: 256, height: 165))
        }
    }
}
