import Foundation

enum Equipment: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case bodyOnly // 0
    case bench // 1
    case barbell // 2
    case pullBar // 3
    case dumbbell // 4
    case exerciseBall // 5
    case kettleBell // 6
    case weightPlate // 7
    case machine // 8
    case other // 9
}

struct EquipmentStruct: Codable {
    var exerciseList: [Exercise]
}
