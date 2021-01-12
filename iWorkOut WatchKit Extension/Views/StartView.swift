import SwiftUI

struct StartView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var dataManager: DataManager
    var body: some View {
        VStack {
        NavigationLink(
            destination: MuscleView(dataManager: dataManager)
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
