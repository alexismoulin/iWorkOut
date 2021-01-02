import SwiftUI

struct RecordView: View {
    @State private var selectedMuscle: MuscleGroup = .chest
    @State private var selectedEquipment: Equipment = .bodyOnly
    var exerciseList: [Exercise] {
        loadData(muscleGroup: selectedMuscle.rawValue, equipment: selectedEquipment.rawValue) ?? [Exercise(id: "999", name: "No Exercise")]
    }
    var body: some View {
        VStack {
            HStack {
                Picker("Muscle", selection: $selectedMuscle) {
                    Text("Chest").tag(MuscleGroup.chest) // 0
                    Text("Biceps").tag(MuscleGroup.biceps) // 1
                    Text("Triceps").tag(MuscleGroup.triceps) // 2
                    Text("Forearm").tag(MuscleGroup.forearm) // 3
                    Text("Back").tag(MuscleGroup.back) // 4
                    Text("Shoulders").tag(MuscleGroup.shoulders) // 5
                    Text("Upper Legs").tag(MuscleGroup.upperLegs) // 6
                    Text("Lower Legs").tag(MuscleGroup.lowerLegs) // 7
                    Text("Abdominals").tag(MuscleGroup.abdominals) // 8
                    Text("Cardio").tag(MuscleGroup.cardio) // 9
                }
                Picker("Equipment", selection: $selectedEquipment) {
                    Text("Body Only").tag(Equipment.bodyOnly) // 0
                    Text("Bench").tag(Equipment.bench) // 1
                    Text("Barbell").tag(Equipment.barbell) // 2
                    Text("Pull Bar").tag(Equipment.pullBar) // 3
                    Text("Dumbbell").tag(Equipment.dumbbell) // 4
                    Text("Exercise Bar").tag(Equipment.exerciseBall) // 5
                    Text("Kettle Bell").tag(Equipment.kettleBell) // 6
                    Text("Weight Plate").tag(Equipment.weightPlate) // 7
                    Text("Machine").tag(Equipment.machine) // 8
                    Text("Other").tag(Equipment.other) // 9
                }
            }
            List(exerciseList) { exercise in
                HStack {
                    Text((exercise.name))
                    Spacer()
                    Text("🏆 3")
                }
            }
        }.navigationTitle("Records")
    }
}
