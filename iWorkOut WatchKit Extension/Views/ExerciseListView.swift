import SwiftUI

struct ExerciseListView: View {
    
    let selectedMuscle: String
    let selectedEquipment: String
    let exerciseList: [Exercise]
    let recordId = "0-0-0"
    let fetched: FetchRequest<Record>
    
    init(selectedMuscle: String, selectedEquipment: String) {
        self.selectedMuscle = selectedMuscle
        self.selectedEquipment = selectedEquipment
        exerciseList = loadData(muscleGroup: selectedMuscle, equipment: selectedEquipment) ?? [Exercise(id: "999", name: "Error")]
        fetched = FetchRequest<Record>(
            entity: Record.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "id = %@", recordId)
        )
    }
    
    var body: some View {
        GeometryReader { geo in
            List(exerciseList) { exercise in
                NavigationLink(destination: DetailView(exercise: exercise)) {
                    HStack {
                        Text(exercise.name)
                        Spacer()
                        Image(exercise.id)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.45)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }.frame(height: 60, alignment: .center)
                }
            }
        }.navigationTitle("\(selectedMuscle) - \(selectedEquipment)")
    }
}
