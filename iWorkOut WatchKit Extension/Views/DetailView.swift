import SwiftUI

struct DetailView: View {

    // MARK: - Properties

    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var dataManager: DataManager

    let exercise: Exercise

    @State private var reps: Double = 0
    @State private var imageAnimationFrame: Int = 0
    @State private var displayInstructions: Bool = false

    @FetchRequest(entity: Record.entity(), sortDescriptors: []) var fetchedResults: FetchedResults<Record>

    var record: Int {
        getRecord(recordList: fetchedResults, exerciseId: exercise.id)
    }

    // MARK: - Components

    func createRecordRow() -> some View {
        HStack {
            VStack {
                Image(systemName: "flame")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.orange)
                    .frame(height: 32)
                Text("\(fetchedResults.first?.calories ?? 0)").fontWeight(.bold)
            }
            Spacer()
            VStack {
                Image(systemName: "crown")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.yellow)
                    .frame(height: 32)
                Text("\(fetchedResults.first?.sum ?? 0)").fontWeight(.bold)
            }
            Spacer()
            VStack {
                ZStack {
                Image(systemName: "heart")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
                    .frame(height: 32)
                Image(systemName: "waveform.path.ecg")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
                    .frame(height: 30)
                }
                Text("TBD").fontWeight(.bold)
            }
        }.padding()
    }

    // MARK: - body

    var body: some View {
        ScrollView {
            VStack {
                Image(imageAnimationFrame % 2 == 0 ? "\(exercise.id)-a" : "\(exercise.id)-b")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                NavigationLink(destination: ActivityView(exercise: exercise)
                                .environment(\.managedObjectContext, dataController.container.viewContext)
                                .environmentObject(dataController)
                                .environmentObject(dataManager)
                ) {
                    Text("START").foregroundColor(.lime)
                }
                .padding(.vertical)
                Divider()
                createRecordRow()
                Spacer()
            }
        }
        .navigationTitle(exercise.name)
        .onAppear(perform: animateExerciseImage)
    }

    // MARK: - functions

    func getRecord(recordList: FetchedResults<Record>, exerciseId: String) -> Int {
        let record = recordList.first(where: {$0.id == exerciseId})
        let record1: Int64 = record?.set1 ?? 0
        let record2: Int64 = record?.set2 ?? 0
        let record3: Int64 = record?.set3 ?? 0
        // let calories: Int64 = record?.calories ?? 0
        return Int(record1 + record2 + record3)
    }

    func animateExerciseImage() {
        for halfSecond in 0..<20 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 * Double(halfSecond)) {
                imageAnimationFrame += 1
            }
        }
    }

}
