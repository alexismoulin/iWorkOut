import SwiftUI

struct ExerciseListView: View {

    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var dataManager: DataManager

    let selectedMuscle: String
    let selectedEquipment: String
    var noExercise: Bool = false

    var exerciseList: [Exercise] {
        loadData(muscleGroup: selectedMuscle, equipment: selectedEquipment) ??
            [Exercise(id: "null", name: "No Exercise", type: "0")]
    }

    var body: some View {
        GeometryReader { geo in
            List(exerciseList) { exercise in
                if exercise.id == "null" {
                    HStack {
                        Text(exercise.name)
                        Spacer()
                        Text("✘")
                            .foregroundColor(.red)
                    }
                } else {
                    NavigationLink(destination: DetailView(
                        dataController: dataController,
                        dataManager: dataManager,
                        exercise: exercise
                    )) {
                        HStack {
                            Text(exercise.name)
                            Spacer()
                            Image("\(exercise.id)-a")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.45)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }.frame(height: 60, alignment: .center)
                    }
                }
            }
        }
        .navigationTitle("\(selectedMuscle) - \(selectedEquipment)")
    }
}
