import Foundation

struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
}

// loader for json data - unused
func createExercises() -> [Exercise] {
    var exerciseArray = [Exercise]()
    let url = Bundle.main.url(forResource: "ExerciseData", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    do {
        let JSON = try JSONDecoder().decode([Exercise].self, from: data)
        print(".........." , JSON , ".......")
        for exercise in JSON {
            let id = exercise.id
            let name = exercise.name
            exerciseArray.append(Exercise(id: id, name: name))
        }
    } catch {
        print(error.localizedDescription)
    }
    
    return exerciseArray
}

//loader for plist data - returns nil if there is any issue duriong the process
func loadData(muscleGroup: String, equipment: String) -> [Exercise]? {
    //load the plist data
    guard let path = Bundle.main.path(forResource: "ExerciseData", ofType: "plist") else { return nil }
    let url = URL(fileURLWithPath: path)
    let data = try! Data(contentsOf: url)
    //cast the plist data to the right datastructure
    guard let fullList = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as?
    [String: [String: [[String: String]]]] else { return nil }
    //get the data only for the selected musclegroup and equipment
    guard let shortList: [[String: String]] = fullList[muscleGroup]?[equipment] else { return nil }
    //put the data inside an  array of Exercise
    var exerciseArray: [Exercise] = []
    for exercise in shortList {
        guard let id = exercise["id"] else { return nil }
        guard let name = exercise["name"] else { return nil }
        exerciseArray.append(Exercise(id: id, name: name))
    }
    return exerciseArray
}
