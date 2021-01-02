import SwiftUI

struct RecordView: View {
    let fetchedResults: FetchedResults<Record>
    let pickerFontSize: CGFloat = 15
    @State private var selectedMuscle: MuscleGroup = .chest
    @State private var selectedEquipment: Equipment = .bodyOnly
    
    var exerciseList: [Exercise] {
        loadData(muscleGroup: selectedMuscle.rawValue, equipment: selectedEquipment.rawValue) ?? [Exercise(id: "999", name: "No Exercise")]
    }
    
    func getRecord(recordList: FetchedResults<Record>, exerciseId: String) -> String {
        let record = recordList.first(where: {$0.id == exerciseId})
        return String(record?.value ?? 0)
    }
    
    func createPickerHeadLiner(text: String, color: Color) -> some View {
        Text(text)
            .foregroundColor(.black)
            .padding(.horizontal, 2)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 2))
    }
    
    var body: some View {
        VStack {
            HStack {
                Picker(selection: $selectedMuscle, label: createPickerHeadLiner(text: "Muscle Group", color: .green)) {
                    Text("Chest").font(.system(size: pickerFontSize)).tag(MuscleGroup.chest) // 0
                    Text("Biceps").font(.system(size: pickerFontSize)).tag(MuscleGroup.biceps) // 1
                    Text("Triceps").font(.system(size: pickerFontSize)).tag(MuscleGroup.triceps) // 2
                    Text("Forearm").font(.system(size: pickerFontSize)).tag(MuscleGroup.forearm) // 3
                    Text("Back").font(.system(size: pickerFontSize)).tag(MuscleGroup.back) // 4
                    Text("Shoulders").font(.system(size: pickerFontSize)).tag(MuscleGroup.shoulders) // 5
                    Text("Upper Legs").font(.system(size: pickerFontSize)).tag(MuscleGroup.upperLegs) // 6
                    Text("Lower Legs").font(.system(size: pickerFontSize)).tag(MuscleGroup.lowerLegs) // 7
                    Text("Abdos").font(.system(size: pickerFontSize)).tag(MuscleGroup.abdos) // 8
                    Text("Cardio").font(.system(size: pickerFontSize)).tag(MuscleGroup.cardio) // 9
                }
                .accentColor(.lime)
                .frame(height: 60)
                .clipped()
                Picker(selection: $selectedEquipment, label: createPickerHeadLiner(text: "Equipment", color: .yellow2)) {
                    Text("Body Only").font(.system(size: pickerFontSize)).tag(Equipment.bodyOnly) // 0
                    Text("Bench").font(.system(size: pickerFontSize)).tag(Equipment.bench) // 1
                    Text("Barbell").font(.system(size: pickerFontSize)).tag(Equipment.barbell) // 2
                    Text("Pull Bar").font(.system(size: pickerFontSize)).tag(Equipment.pullBar) // 3
                    Text("Dumbbell").font(.system(size: pickerFontSize)).tag(Equipment.dumbbell) // 4
                    Text("Ball").font(.system(size: pickerFontSize)).tag(Equipment.ball) // 5
                    Text("Kettle Bell").font(.system(size: pickerFontSize)).tag(Equipment.kettleBell) // 6
                    Text("Weight Plate").font(.system(size: pickerFontSize)).tag(Equipment.weightPlate) // 7
                    Text("Machine").font(.system(size: pickerFontSize)).tag(Equipment.machine) // 8
                    Text("Other").font(.system(size: pickerFontSize)).tag(Equipment.other) // 9
                }.frame(height: 60).clipped()
            }
            List(exerciseList) { exercise in
                HStack {
                    Text((exercise.name))
                    Spacer()
                    Text("🏆 \(getRecord(recordList: fetchedResults, exerciseId: exercise.id))")
                }
            }
        }.navigationTitle("Records")
    }
}
