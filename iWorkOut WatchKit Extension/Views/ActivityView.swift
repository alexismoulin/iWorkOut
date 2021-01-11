import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentation
    
    let exercise: Exercise
    
    @State private var record: [Int: Int] = [1: 0, 2: 0, 3: 0]
    @State private var setValue: Double = 0
    @State private var isFocused: Bool = false
    @State private var set: Int = 1
    @State private var timeRemaining: Int = 3
    @State private var percent: Double = 0
    @State private var title: String = "Get Ready!"
    @State private var isPresented: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertBody: String = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @FetchRequest(entity: Record.entity(), sortDescriptors: []) var fetchedResults: FetchedResults<Record>
    
    var CDRecord: Record? {
        fetchedResults.first(where: {$0.id == exercise.id})
    }
    
    func getRecord(CDRecord: Record?, exerciseId: String) -> Int64 {
        if let record = CDRecord {
            let record1: Int64 = record.set1
            let record2: Int64 = record.set2
            let record3: Int64 = record.set3
            return record1 + record2 + record3
        } else {
            return 0
        }
    }
    
    var body: some View {
        VStack {
            if set < 4 {
            if timeRemaining > 0 {
                ZStack {
                    PercentageRing(
                        ringWidth: 20, percent: percent ,
                        backgroundColor: Color.green.opacity(0.2),
                        foregroundColors: [.green, .blue]
                    )
                    Text("\(timeRemaining)")
                        .font(.largeTitle)
                        .onTapGesture {
                            timeRemaining = 0
                        }
                        .onReceive(timer) { _ in
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                                withAnimation {
                                    percent += set == 1 ? 100/3 : 100/120
                                }
                            }
                        }
                }
            } else {
                HStack {
                    Text("Reps")
                    Spacer()
                    Text("\(Int(setValue))")
                        .padding()
                        .frame(width: 50)
                        .contentShape(Rectangle())
                        .focusable { isFocused = $0 }
                        .digitalCrownRotation($setValue, from: 0, through: 100, by: 1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(isFocused ? Color.green : Color.gray, lineWidth: 2))
                }.onAppear {
                    title = "Set \(set)"
                }
                Spacer()
                Button("Done") {
                    record[set] = Int(setValue)
                    title = "Rest"
                    timeRemaining = 120
                    set += 1
                    percent = 0
                }
                HStack {
                    Text("Set 1: \(record[1] ?? 0)").font(.system(size: 12)).foregroundColor(.gray)
                    Text("Set 2: \(record[2] ?? 0)").font(.system(size: 12)).foregroundColor(.gray)
                    Text("Set 3: \(record[3] ?? 0)").font(.system(size: 12)).foregroundColor(.gray)
                }
            }
            } else {
                Text("Set 1: \(record[1] ?? 0)")
                Text("Set 2: \(record[2] ?? 0)")
                Text("Set 3: \(record[3] ?? 0)")
                Button("Save") {
                    if getRecord(CDRecord: CDRecord, exerciseId: exercise.id) == 0 {
                        //create new Record
                        alertTitle = "Congratulations"
                        alertBody = "You have completed a New Exercise. Your record is: \(record[1]! + record[2]! + record[3]!)"
                        let newRecord = Record(context: dataController.container.viewContext)
                        newRecord.id = exercise.id
                        newRecord.set1 = Int64(record[1]!)
                        newRecord.set2 = Int64(record[2]!)
                        newRecord.set3 = Int64(record[3]!)
                        print("saving new record")
                        dataController.save()
                        isPresented = true
                    } else {
                        // update existing record
                        if record[1]! + record[2]! + record[3]! > getRecord(CDRecord: CDRecord, exerciseId: exercise.id) {
                            alertTitle = "Congratulations"
                            alertBody = "You have beaten your previous record of \(CDRecord!.set1 + CDRecord!.set2 + CDRecord!.set3). \nYour new record is: \(record[1]! + record[2]! + record[3]!)"
                            CDRecord?.set1 = Int64(record[1]!)
                            CDRecord?.set2 = Int64(record[2]!)
                            CDRecord?.set3 = Int64(record[3]!)
                            print("preparing update your record")
                            dataController.save()
                            isPresented = true
                        } else {
                            // didnt beat your record
                            alertTitle = "Try again"
                            alertBody = "You didn't beat your previous record of \(CDRecord!.set1 + CDRecord!.set2 + CDRecord!.set3). \nYour score is: \(record[1]! + record[2]! + record[3]!)"
                            isPresented = true
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
        .alert(isPresented: $isPresented) { () -> Alert in
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: .default(Text("Ok"), action: {
                presentation.wrappedValue.dismiss()
            }))
        }
    }
}
