import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var dataManager: DataManager
    
    let exercise: Exercise
    
    @State private var reps: Double = 0
    @State private var displayInstructions: Bool = false
    
    @FetchRequest(entity: Record.entity(), sortDescriptors: []) var fetchedResults: FetchedResults<Record>
    
    func getRecord(recordList: FetchedResults<Record>, exerciseId: String) -> String {
        let record = recordList.first(where: {$0.id == exerciseId})
        let record1: Int64 = record?.set1 ?? 0
        let record2: Int64 = record?.set2 ?? 0
        let record3: Int64 = record?.set3 ?? 0
        return String(record1 + record2 + record3)
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
                NavigationLink(destination: ActivityView(dataManager: dataManager, exercise: exercise)
                                .environment(\.managedObjectContext, dataController.container.viewContext)
                                .environmentObject(dataController)
                ) {
                    Text("Start")
                }
                Divider()
                Text("🏆").font(.largeTitle)
                Text("\(getRecord(recordList: fetchedResults, exerciseId: exercise.id))")
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
