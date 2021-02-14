import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var dataManager: DataManager
    
    let exercise: Exercise
    
    @State private var reps: Double = 0
    @State private var displayInstructions: Bool = false
    
    @FetchRequest(entity: Record.entity(), sortDescriptors: []) var fetchedResults: FetchedResults<Record>
    
    func getRecord(recordList: FetchedResults<Record>, exerciseId: String) -> (set1: Int64, set2: Int64, set3: Int64, total: Int64, calories: Int64) {
        let record = recordList.first(where: {$0.id == exerciseId})
        let record1: Int64 = record?.set1 ?? 0
        let record2: Int64 = record?.set2 ?? 0
        let record3: Int64 = record?.set3 ?? 0
        let calories: Int64 = record?.calories ?? 0
        return (set1: record1, set2: record2, set3: record3, total: record1 + record2 + record3, calories: calories)
    }
    
    var record: (set1: Int64, set2: Int64, set3: Int64, total: Int64, calories: Int64) {
        getRecord(recordList: fetchedResults, exerciseId: exercise.id)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack(alignment: .topTrailing) {
                    Image(exercise.id)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Image("instruction")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .shadow(radius: 2)
                        .offset(x: -10, y: 10)
                        .onTapGesture {
                            displayInstructions = true
                        }
                }
                NavigationLink(destination: ActivityView(exercise: exercise)
                                .environment(\.managedObjectContext, dataController.container.viewContext)
                                .environmentObject(dataController)
                                .environmentObject(dataManager)
                ) {
                    Text("START").foregroundColor(.lime)
                }
                .padding(.vertical)
                Divider()
                Text("🏆").font(.largeTitle)
                Text("\(record.total)").fontWeight(.bold)
                Spacer()
            }
        }
        .navigationTitle(exercise.name)
        .sheet(isPresented: $displayInstructions, content: {
            ScrollView {
                Text("Instructions")
                Divider()
                Text(exercise.instructions).font(.system(size: 12))
            }
        })
    }
}
