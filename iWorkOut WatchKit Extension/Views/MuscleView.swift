import SwiftUI

struct MuscleView: View {
    var body: some View {
        List(MuscleGroup.allCases) { muscle in
            NavigationLink(destination: EquipmentView(selectedMuscle: muscle.rawValue)) {
                Text(muscle.rawValue.uppercased()).foregroundColor(.lime)
            }
        }.navigationTitle("Muscle Group")
    }
}
