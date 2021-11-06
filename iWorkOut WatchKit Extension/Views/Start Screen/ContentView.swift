import SwiftUI

struct ContentView: View {

    // MARK: - Properties

    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var dataManager: DataManager
    @FetchRequest(entity: Record.entity(), sortDescriptors: []) var fetchedResults: FetchedResults<Record>

    let debugMode: Bool = false

    // MARK: - Components

    var startButton: some View {
        NavigationLink(
            destination: MuscleView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(dataManager),
            label: {
                HStack {
                    Text("Start an Exercise")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .foregroundColor(.lime)
                    Spacer()
                    Image("start")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .padding(.horizontal)
                }
            }
        )
    }

    var recordButton: some View {
        NavigationLink(
            destination: RecordView(fetchedResults: fetchedResults)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(dataManager),
            label: {
                HStack {
                    Text("Check your Records")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .foregroundColor(.yellow2)
                    Spacer()
                    Image(systemName: "crown.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.yellow2)
                        .padding(.horizontal)
                }
            }
        )
    }

    // MARK: - body

    var body: some View {
        VStack {
            startButton.padding(.top)
            Spacer()
            recordButton.padding(.bottom)
        }
        .onAppear(perform: requestPermission)
        .navigationTitle("iWorkOut!")
        .navigationBarTitleDisplayMode(.inline)
    }
}
