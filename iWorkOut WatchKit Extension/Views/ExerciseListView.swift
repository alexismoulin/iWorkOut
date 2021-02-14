import SwiftUI

struct ExerciseListView: View {
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var dataManager: DataManager
    let selectedMuscle: String
    let selectedEquipment: String
    
    var noExercise: Bool = false
    
    var exerciseList: [Exercise] {
        loadData(muscleGroup: selectedMuscle, equipment: selectedEquipment) ?? [Exercise(id: "null", name: "No Exercise", instructions: "no data")]
    }
    
    var body: some View {
        GeometryReader { geo in
            List(exerciseList) { exercise in
                if exercise.id == "null" {
                    Text(exercise.name)
                } else {
                    NavigationLink(destination: DetailView(exercise: exercise)
                                    .environment(\.managedObjectContext, dataController.container.viewContext)
                                    .environmentObject(dataController)
                                    .environmentObject(dataManager)
                    ) {
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
            }
        }
        .navigationTitle("\(selectedMuscle) - \(selectedEquipment)")
    }
}
