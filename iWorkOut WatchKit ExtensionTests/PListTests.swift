import XCTest
@testable import iWorkOut_WatchKit_Extension

class PListTests: XCTestCase {

    func testLoadAllData() throws {
        let results = try Exercise.loadAll()
        XCTAssertEqual(results.count, 134)
        XCTAssertEqual(results.muscleFilter(filter: .chest).count, 25)
        XCTAssertEqual(results.muscleFilter(filter: .biceps).count, 13)
        XCTAssertEqual(results.muscleFilter(filter: .triceps).count, 14)
        XCTAssertEqual(results.muscleFilter(filter: .forearm).count, 11)
        XCTAssertEqual(results.muscleFilter(filter: .back).count, 21)
        XCTAssertEqual(results.muscleFilter(filter: .shoulders).count, 23)
        XCTAssertEqual(results.muscleFilter(filter: .upperLegs).count, 20)
    }

    func testUniqueData() throws {
        let results = try Exercise.loadAll()
        let listOfIDs = results.map { $0.id }
        let uniqueIds = listOfIDs.uniqued()
        XCTAssertTrue(listOfIDs.elementsEqual(uniqueIds))
    }

    func testMuscleGroupID() throws {
        let results = try Exercise.loadAll()
        for result in results {
            let firstCharacter = result.id.character(at: 0)!
            switch firstCharacter {
            case "0": XCTAssertEqual(result.muscleGroup, MuscleGroup.chest.rawValue, "\(result.id)")
            case "1": XCTAssertEqual(result.muscleGroup, MuscleGroup.biceps.rawValue, "\(result.id)")
            case "2": XCTAssertEqual(result.muscleGroup, MuscleGroup.triceps.rawValue, "\(result.id)")
            case "3": XCTAssertEqual(result.muscleGroup, MuscleGroup.forearm.rawValue, "\(result.id)")
            case "4": XCTAssertEqual(result.muscleGroup, MuscleGroup.back.rawValue, "\(result.id)")
            case "5": XCTAssertEqual(result.muscleGroup, MuscleGroup.shoulders.rawValue, "\(result.id)")
            case "6": XCTAssertEqual(result.muscleGroup, MuscleGroup.upperLegs.rawValue, "\(result.id)")
            case "7": XCTAssertEqual(result.muscleGroup, MuscleGroup.lowerLegs.rawValue, "\(result.id)")
            case "8": XCTAssertEqual(result.muscleGroup, MuscleGroup.abdos.rawValue, "\(result.id)")
            case "9": XCTAssertEqual(result.muscleGroup, MuscleGroup.cardio.rawValue, "\(result.id)")
            default: fatalError("\(result.id) incorrect")
            }
        }
    }

    func testEquipmentID() throws {
        let results = try Exercise.loadAll()
        for result in results {
            let thirdCharacter = result.id.character(at: 2)!
            switch thirdCharacter {
            case "0": XCTAssertEqual(result.equipment, Equipment.bodyOnly.rawValue, "\(result.id)")
            case "1": XCTAssertEqual(result.equipment, Equipment.bench.rawValue, "\(result.id)")
            case "2": XCTAssertEqual(result.equipment, Equipment.barbell.rawValue, "\(result.id)")
            case "3": XCTAssertEqual(result.equipment, Equipment.pullBar.rawValue, "\(result.id)")
            case "4": XCTAssertEqual(result.equipment, Equipment.dumbbell.rawValue, "\(result.id)")
            case "5": XCTAssertEqual(result.equipment, Equipment.cable.rawValue, "\(result.id)")
            case "6": XCTAssertEqual(result.equipment, Equipment.kettleBell.rawValue, "\(result.id)")
            case "7": XCTAssertEqual(result.equipment, Equipment.weightPlate.rawValue, "\(result.id)")
            case "8": XCTAssertEqual(result.equipment, Equipment.machine.rawValue, "\(result.id)")
            case "9": XCTAssertEqual(result.equipment, Equipment.other.rawValue, "\(result.id)")
            default: fatalError("\(result.id) incorrect")
            }
        }
    }

    func testTypeNotWeight() throws {
        let results = try Exercise.loadAll()
        for exercice in results {
            if exercice.id.character(at: 2)! == "0" || exercice.id.character(at: 2)! == "1" {
                XCTAssertNotEqual(exercice.type, "weight", "\(exercice.id)")
            }
        }
    }

}
