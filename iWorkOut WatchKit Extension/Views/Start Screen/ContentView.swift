import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var dataManager: DataManager
    @FetchRequest(entity: Record.entity(), sortDescriptors: []) var fetchedResults: FetchedResults<Record>

    let debugMode: Bool = false

    var body: some View {
        TabView {
            StartView()
                .environmentObject(dataController)
                .environmentObject(dataManager)
                .environment(\.managedObjectContext, dataController.container.viewContext)
            RecordView(fetchedResults: fetchedResults)
            if debugMode {
                DebugView()
                    .environmentObject(dataController)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
            }
        }.onAppear(perform: requestPermission)
    }
}
