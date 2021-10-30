import Foundation

struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    var muscleGroup: String
    var equipment: String

    static let missing = Exercise(id: "null", name: "No Exercise", type: "", muscleGroup: "", equipment: "")

    static func loadAll() throws -> [Exercise] {
        // load the plist data
        guard  let path     = Bundle.main.path(forResource: "ExerciseDatav2", ofType: "plist"),
               let xml      = FileManager.default.contents(atPath: path)
        else { fatalError("Not able to load ExerciseDatav2") }
        // insure conformance to Exercise struct
        let fullList = try PropertyListDecoder().decode([Exercise].self, from: xml)
        return fullList
    }

    static func loadData(muscleGroup: String, equipment: String) -> [Exercise]? {
        guard let fullList = try? loadAll() else { return nil }
        let shortList = fullList.filter { $0.equipment == equipment && $0.muscleGroup == muscleGroup }
        if shortList.isEmpty {
            return nil
        } else {
            return shortList
        }
    }

}
