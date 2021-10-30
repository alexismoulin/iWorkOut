import SwiftUI

struct DebugView: View {
    @EnvironmentObject var dataController: DataController
    var body: some View {
        VStack {
            Button("Delete all") {
                dataController.deleteAll()
                print("All records deleted")
            }
            Button("Create samples") {
                dataController.createSample()
                print("Samples created")
            }
        }
    }
}
