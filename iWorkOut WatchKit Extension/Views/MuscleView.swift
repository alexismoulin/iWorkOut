import SwiftUI

struct MuscleView: View {
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var dataManager: DataManager
    var body: some View {
        List(MuscleGroup.allCases) { muscle in
            NavigationLink(destination: EquipmentView(selectedMuscle: muscle.rawValue)
                            .environment(\.managedObjectContext, dataController.container.viewContext)
                            .environmentObject(dataController)
                            .environmentObject(dataManager)
            ) {
                HStack {
                    Text(muscle.rawValue.uppercased()).foregroundColor(.lime)
                    Spacer()
                    Image(muscle.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50, alignment: .trailing)
                }
            }
        }.navigationTitle("Exercise")
    }
}
