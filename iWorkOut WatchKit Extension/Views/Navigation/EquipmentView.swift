import SwiftUI

struct EquipmentView: View {
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var dataManager: DataManager
    let selectedMuscle: String
    var body: some View {
        List(Equipment.allCases) { equipment in
            NavigationLink(
                destination: ExerciseListView(selectedMuscle: selectedMuscle, selectedEquipment: equipment.rawValue
                )
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(dataManager)
            ) {
                HStack {
                    Text(equipment.rawValue.uppercased()).foregroundColor(.yellow2)
                    Spacer()
                    Image(equipment.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50, alignment: .trailing)
                }
            }
        }
        .navigationTitle(selectedMuscle)
        .navigationBarTitleDisplayMode(.inline)
    }
}
