import SwiftUI

struct MuscleView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc
    /*
    let recordId = "0-0-0"
    let fetched: FetchRequest<Record>
    init() {
        fetched = FetchRequest<Record>(
            entity: Record.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "id = %@", recordId)
        )
    }
 */
    var body: some View {
        //fetched.wrappedValue.isEmpty ? Text("Not working") : Text("\(fetched.wrappedValue.first!.value)")
        
        List(MuscleGroup.allCases) { muscle in
            NavigationLink(destination: EquipmentView(selectedMuscle: muscle.rawValue)) {
                Text(muscle.rawValue.uppercased()).foregroundColor(.lime)
            }
        }.navigationTitle("Muscle Group")
    }
}
