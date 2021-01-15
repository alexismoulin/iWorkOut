import SwiftUI

struct DebugView: View {
    @EnvironmentObject var dataController: DataController
    var body: some View {
        Button("Delete all") {
            dataController.deleteAll()
            print("All records deleted")
        }
    }
}
