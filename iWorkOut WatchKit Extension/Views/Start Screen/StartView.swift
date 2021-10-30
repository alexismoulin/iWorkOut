import SwiftUI
import UserNotifications

struct StartView: View {
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        VStack {
            NavigationLink(
                destination: MuscleView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(dataController)
                    .environmentObject(dataManager),
                label: {
                    Text("Start an Exercise")
                }
            )
        }
    }
}
