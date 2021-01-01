import SwiftUI

struct MuscleView: View {
    @EnvironmentObject var dataController: DataController
    var body: some View {
        List(MuscleGroup.allCases) { muscle in
            NavigationLink(destination: EquipmentView(selectedMuscle: muscle.rawValue)
                            .environment(\.managedObjectContext, dataController.container.viewContext)
                            .environmentObject(dataController)
            ) {
                Text(muscle.rawValue.uppercased()).foregroundColor(.lime)
            }
        }.navigationTitle("Muscle Group")
    }
}
