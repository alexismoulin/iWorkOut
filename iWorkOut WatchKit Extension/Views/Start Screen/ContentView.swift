import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var dataManager: DataManager
    @FetchRequest(entity: Record.entity(), sortDescriptors: []) var fetchedResults: FetchedResults<Record>
    var body: some View {
        TabView {
            StartView()
                .environmentObject(dataController)
                .environmentObject(dataManager)
                .environment(\.managedObjectContext, dataController.container.viewContext)
            RecordView(fetchedResults: fetchedResults)
            DebugView()
                .environmentObject(dataController)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }.onAppear(perform: requestPermission)
    }
}
