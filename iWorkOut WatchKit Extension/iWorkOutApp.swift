import SwiftUI

@main
struct iWorkOutApp: App {
    @StateObject var dataController: DataController // CoreData + Cloudkit
    @StateObject var dataManager: DataManager // HealthKit
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
        let dataManager = DataManager()
        _dataManager = StateObject(wrappedValue: dataManager)
        print("starting")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(dataManager: dataManager)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(dataController)
            }
        }
    }
}
