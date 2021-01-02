import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataController: DataController
    
    let exercise: Exercise
    
    @State private var reps: Double = 0
    @State private var isFocused: Bool = false
    @State private var displayInstructions: Bool = false
    
    @FetchRequest(entity: Record.entity(), sortDescriptors: []) var fetchedResults: FetchedResults<Record>
    
    var record: Record? {
        fetchedResults.first(where: {$0.id == exercise.id})
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
                        if Int64(reps) > record.value {
                            record.value = Int64(reps)
                            dataController.save()
                        } else {
                            return
                        }
                    } else {
                        let newRecord = Record(context: dataController.container.viewContext)
                        newRecord.id = exercise.id
                        newRecord.value = Int64(reps)
                    }
                }
                Divider()
                Text("🏆").font(.largeTitle)
                Text("\(record?.value ?? 0)")
                Spacer()
            }
        }
        .navigationTitle(exercise.name)
        .sheet(isPresented: $displayInstructions, content: {
            ScrollView {
                Text("How to perform the exercise").font(.system(size: 12)).fontWeight(.bold)
                Divider()
                Text("test data").font(.system(size: 12))
            }
        })
    }
}
