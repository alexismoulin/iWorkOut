import SwiftUI

struct ExerciseListView: View {

    // MARK: - Properties

    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var dataManager: DataManager

    let selectedMuscle: String
    let selectedEquipment: String
    var noExercise: Bool = false

    var exerciseList: [Exercise] {
        Exercise.loadData(muscleGroup: selectedMuscle, equipment: selectedEquipment) ?? [.missing]
    }

    // MARK: - components

    func createMissingExercise(name: String) -> some View {
        HStack {
            Text(name)
            Spacer()
            Text("✘")
                .foregroundColor(.red)
        }
    }

    @ViewBuilder
    func createExerciseImage(exercise: Exercise) -> some View {
        if exercise.type == ExerciseType.duration.rawValue {
            Image(exercise.id)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            Image("\(exercise.id)-a")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    // MARK: - body

    var body: some View {
        GeometryReader { geo in
            List(exerciseList) { exercise in
                if exercise.id == "null" {
                    createMissingExercise(name: exercise.name)
                } else {
                    NavigationLink(
                        destination: DetailView(
                            dataController: dataController,
                            dataManager: dataManager,
                            exercise: exercise
                        )
                    ) {
                        HStack {
                            Text(exercise.name)
                                .font(.caption2)
                            Spacer()
                            createExerciseImage(exercise: exercise)
                                .frame(width: geo.size.width * 0.45)
                        }.frame(height: 60, alignment: .center)
                    }
                }
            }
        }
        .navigationTitle("\(selectedMuscle) - \(selectedEquipment)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
