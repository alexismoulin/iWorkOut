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
    case abdos // 8
    case cardio // 9
}

enum Equipment: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case bodyOnly // 0
    case bench // 1
    case barbell // 2
    case pullBar // 3
    case dumbbell // 4
    case cable // 5
    case kettleBell // 6
    case weightPlate // 7
    case machine // 8
    case other // 9
}

enum ExerciseType: String, CaseIterable {
    case reps, duration, weight
}
