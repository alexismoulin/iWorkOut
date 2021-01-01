import SwiftUI

struct ExerciseListView: View {
    @EnvironmentObject var dataController: DataController
    let selectedMuscle: String
    let selectedEquipment: String
    
    var exerciseList: [Exercise] {
        loadData(muscleGroup: selectedMuscle, equipment: selectedEquipment) ?? [Exercise(id: "999", name: "Error")]
    }
    
    var body: some View {
        GeometryReader { geo in
            List(exerciseList) { exercise in
                NavigationLink(destination: DetailView(exercise: exercise)
                                .environment(\.managedObjectContext, dataController.container.viewContext)
                                .environmentObject(dataController)
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
        .navigationTitle("\(selectedMuscle) - \(selectedEquipment)")
    }
}
