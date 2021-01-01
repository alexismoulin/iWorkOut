import SwiftUI

struct EquipmentView: View {
    @EnvironmentObject var dataController: DataController
    let selectedMuscle: String
    var body: some View {
        List(Equipment.allCases) { equipment in
            NavigationLink(destination: ExerciseListView(selectedMuscle: selectedMuscle, selectedEquipment: equipment.rawValue)
                            .environment(\.managedObjectContext, dataController.container.viewContext)
                            .environmentObject(dataController)
            ) {
                Text(equipment.rawValue.uppercased()).foregroundColor(.yellow2)
            }
        }.navigationTitle(selectedMuscle)
    }
}
