import XCTest
@testable import iWorkOut_WatchKit_Extension

class PListTests: XCTestCase {

    func testLoadAllData() throws {
        let results = try Exercise.loadAll()
        XCTAssertEqual(results.count, 35)
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
            case "0": XCTAssertEqual(result.muscleGroup, MuscleGroup.chest.rawValue)
            case "1": XCTAssertEqual(result.muscleGroup, MuscleGroup.biceps.rawValue)
            case "2": XCTAssertEqual(result.muscleGroup, MuscleGroup.triceps.rawValue)
            case "3": XCTAssertEqual(result.muscleGroup, MuscleGroup.forearm.rawValue)
            case "4": XCTAssertEqual(result.muscleGroup, MuscleGroup.back.rawValue)
            case "5": XCTAssertEqual(result.muscleGroup, MuscleGroup.shoulders.rawValue)
            case "6": XCTAssertEqual(result.muscleGroup, MuscleGroup.upperLegs.rawValue)
            case "7": XCTAssertEqual(result.muscleGroup, MuscleGroup.lowerLegs.rawValue)
            case "8": XCTAssertEqual(result.muscleGroup, MuscleGroup.abdos.rawValue)
            case "9": XCTAssertEqual(result.muscleGroup, MuscleGroup.cardio.rawValue)
            default: fatalError("\(result.id) incorrect")
            }
        }
    }

    func testEquipmentID() throws {
        let results = try Exercise.loadAll()
        for result in results {
            let thirdCharacter = result.id.character(at: 2)!
            switch thirdCharacter {
            case "0": XCTAssertEqual(result.equipment, Equipment.bodyOnly.rawValue)
            case "1": XCTAssertEqual(result.equipment, Equipment.bench.rawValue)
            case "2": XCTAssertEqual(result.equipment, Equipment.barbell.rawValue)
            case "3": XCTAssertEqual(result.equipment, Equipment.pullBar.rawValue)
            case "4": XCTAssertEqual(result.equipment, Equipment.dumbbell.rawValue)
            case "5": XCTAssertEqual(result.equipment, Equipment.cable.rawValue)
            case "6": XCTAssertEqual(result.equipment, Equipment.kettleBell.rawValue)
            case "7": XCTAssertEqual(result.equipment, Equipment.weightPlate.rawValue)
            case "8": XCTAssertEqual(result.equipment, Equipment.machine.rawValue)
            case "9": XCTAssertEqual(result.equipment, Equipment.other.rawValue)
            default: fatalError("\(result.id) incorrect")
            }
        }
    }

    func testLoadData() {
        guard let results = Exercise.loadData(
            muscleGroup: MuscleGroup.chest.rawValue,
            equipment: Equipment.machine.rawValue)
        else {
            fatalError("cannot load data")
        }
        XCTAssertGreaterThan(results.count, 0)
        XCTAssertEqual(results[0].id.character(at: 0), "0")
        XCTAssertEqual(results[0].id.character(at: 2), "8")
    }

}
