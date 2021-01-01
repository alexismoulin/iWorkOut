import SwiftUI

@main
struct iWorkOutApp: App {
    @StateObject var dataController: DataController
    init() {
        let dataController = DataController(inMemory: true)
        _dataController = StateObject(wrappedValue: dataController)
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MuscleView()
                    .environmentObject(dataController)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
            }
        }
    }
}
