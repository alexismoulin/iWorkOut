import Foundation

enum MuscleGroup: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case chest // 0
    case biceps // 1
    case triceps // 2
    case forearm // 3
    case back // 4
    case shoulders // 5
    case upperLegs // 6
    case lowerLegs // 7
    case abdominals // 8
    case cardio // 9
}

struct MuscleStruct: Codable {
    var equipmentDict: [String: EquipmentStruct]
}
