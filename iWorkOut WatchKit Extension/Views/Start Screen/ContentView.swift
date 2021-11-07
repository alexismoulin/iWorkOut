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
                    VStack {
                        Text("Start an")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.lime)
                        Text("Exercise")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.lime)
                    }.frame(width: 100)
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
                    VStack {
                        Text("Check your")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.yellow2)
                        Text("Records")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.yellow2)
                    }.frame(width: 100)
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
            startButton
                .padding(.top)
                .padding(.top)
            Spacer()
            recordButton.padding(.bottom)
        }
        .onAppear(perform: requestPermission)
        .navigationTitle("iWorkOut!")
        .navigationBarTitleDisplayMode(.inline)
    }
}
