import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var dataManager: DataManager
    @FetchRequest(entity: Record.entity(), sortDescriptors: []) var fetchedResults: FetchedResults<Record>
    var body: some View {
        TabView {
            StartView(dataManager: dataManager)
                .environmentObject(dataController)
                .environment(\.managedObjectContext, dataController.container.viewContext)
            RecordView(fetchedResults: fetchedResults)
        }
    }
}
