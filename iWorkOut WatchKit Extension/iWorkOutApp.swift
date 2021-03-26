import SwiftUI

@main
// swiftlint:disable:next type_name
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
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(dataController)
                    .environmentObject(dataManager)
            }
        }
    }
}
