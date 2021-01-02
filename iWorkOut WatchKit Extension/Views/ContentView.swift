import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    @FetchRequest(entity: Record.entity(), sortDescriptors: []) var fetchedResults: FetchedResults<Record>
    var body: some View {
        TabView {
            StartView()
                .environmentObject(dataController)
                .environment(\.managedObjectContext, dataController.container.viewContext)
            RecordView(fetchedResults: fetchedResults)
        }
    }
}
