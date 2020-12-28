import SwiftUI

@main
struct iWorkOutApp: App {
    @StateObject var dataController: DataController
    init() {
        let dataController = DataController(inMemory: true)
        _dataController = StateObject(wrappedValue: dataController)
        dataController.createSamples()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MuscleView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(dataController)
            }
        }
    }
}
