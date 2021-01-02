import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    var body: some View {
        TabView {
            MuscleView()
                .environmentObject(dataController)
                .environment(\.managedObjectContext, dataController.container.viewContext)
            RecordView()
        }
    }
}
