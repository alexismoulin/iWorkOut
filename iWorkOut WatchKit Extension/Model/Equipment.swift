import Foundation

enum Equipment: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case bodyOnly // 0
    case bench // 1
    case bands // 2
    case barbell // 3
    case ezBar // 4
    case pullBar // 5
    case dumbbell // 6
    case exerciseBall // 7
    case kettleBell // 8
    case cardioMachine // 9
    case strengthMachine // 10
    case weightPlate // 11
    case other // 12
}

struct EquipmentStruct: Codable {
    var exerciseList: [Exercise]
}
