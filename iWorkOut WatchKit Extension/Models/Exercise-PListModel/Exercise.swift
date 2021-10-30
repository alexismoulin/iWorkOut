import Foundation

enum ExerciseType: String, CaseIterable {
    case rep, duration, weight
}

struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    var muscleGroup: String = ""
    var equipment: String = ""

    // loader for plist data - returns nil if there is any issue duriong the process
    static func loadData(muscleGroup: String, equipment: String) -> [Exercise]? {
        // load the plist data
        guard let path = Bundle.main.path(forResource: "ExerciseData", ofType: "plist") else { return nil }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return nil }
        // cast the plist data to the right datastructure
        guard let fullList = try? PropertyListSerialization.propertyList(
            from: data,
            options: .mutableContainers,
            format: nil
        ) as? [String: [String: [[String: String]]]] else { return nil }
        // get the data only for the selected musclegroup and equipment
        guard let shortList: [[String: String]] = fullList[muscleGroup]?[equipment] else { return nil }
        // put the data inside an  array of Exercise
        var exerciseArray: [Exercise] = []
        for exercise in shortList {
            guard let id = exercise["id"] else { return nil }
            guard let name = exercise["name"] else { return nil }
            guard let type = exercise["type"] else { return nil }
            exerciseArray.append(Exercise(id: id, name: name, type: type))
        }
        if exerciseArray.isEmpty {
            return nil
        } else {
            return exerciseArray
        }
    }

    // loader for plist data - returns nil if there is any issue during the process
    static func loadDatav2(muscleGroup: String, equipment: String) -> [Exercise]? {
        // load the plist data
        guard  let path     = Bundle.main.path(forResource: "ExerciseData", ofType: "plist"),
               let xml      = FileManager.default.contents(atPath: path),
               let fullList = try? PropertyListDecoder().decode([Exercise].self, from: xml) else { return nil }
        // filter the array for relevant items (equipement and muscleGroup)
        let shortList = fullList.filter { $0.equipment == equipment && $0.muscleGroup == muscleGroup }
        return shortList
    }

    static func loadAll() throws -> [Exercise] {
        // load the plist data
        guard  let path     = Bundle.main.path(forResource: "ExerciseDatav2", ofType: "plist"),
               let xml      = FileManager.default.contents(atPath: path)
        else { fatalError("Not able to load ExerciseDatav2") }
        // insure conformance to Exercise struct
        let fullList = try PropertyListDecoder().decode([Exercise].self, from: xml)
        return fullList
    }

}
