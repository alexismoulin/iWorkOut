import SwiftUI

struct EquipmentView: View {
    let selectedMuscle: String
    var body: some View {
        List(Equipment.allCases) { equipment in
            NavigationLink(destination: ExerciseListView(selectedMuscle: selectedMuscle, selectedEquipment: equipment.rawValue)) {
                Text(equipment.rawValue.uppercased()).foregroundColor(.yellow2)
            }
        }.navigationTitle(selectedMuscle)
    }
}
