import SwiftUI

struct StartView: View {
    @EnvironmentObject var dataController: DataController
    var body: some View {
        VStack {
        NavigationLink(
            destination: MuscleView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController),
            label: {
                Text("Start an Exercise")
            })
            Button("Delete all") {
                dataController.deleteAll()
                print("records deleted")
            }
        }
    }
}
