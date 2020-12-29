import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataController: DataController
    
    let exercise: Exercise
    let testId = "0-0-0"
    
    @State private var reps: Double = 0
    @State private var isFocused: Bool = false
    
    @FetchRequest(entity: Record.entity(), sortDescriptors: []) var fetchedResults: FetchedResults<Record>
    
    var record: Record? {
        fetchedResults.first(where: {$0.id == exercise.id})
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(exercise.id)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Divider()
                HStack {
                    Text("Reps")
                    Spacer()
                    Text("\(Int(reps))")
                        .padding()
                        .frame(width: 50)
                        .contentShape(Rectangle())
                        .focusable { isFocused = $0 }
                        .digitalCrownRotation($reps, from: 0, through: 100, by: 1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(isFocused ? Color.green : Color.gray, lineWidth: 2))
                }
                Button("Save"){
                    if let record = record {
                        if Int16(reps) > record.value {
                            record.value = Int16(reps)
                            dataController.save()
                        } else {
                            return
                        }
                    } else {
                        let newRecord = Record(context: dataController.container.viewContext)
                        newRecord.id = exercise.id
                        newRecord.value = Int16(reps)
                    }
                }
                Divider()
                Text("🏆").font(.largeTitle)
                Text("\(record?.value ?? 0)")
                Spacer()
            }
        }.navigationTitle(exercise.name)
    }
}
