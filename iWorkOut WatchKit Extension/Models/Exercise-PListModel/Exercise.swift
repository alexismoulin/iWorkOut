import Foundation

struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
    let type: String

    enum ExerciseType: String, CaseIterable {
        case rep, duration, weight
    }

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
}
