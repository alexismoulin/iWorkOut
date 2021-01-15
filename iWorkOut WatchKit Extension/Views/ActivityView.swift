import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentation
    
    let exercise: Exercise
    
    @State private var record: [Int: Int] = [1: 0, 2: 0, 3: 0]
    @State private var setValue: Double = 0
    @State private var isFocused: Bool = false
    @State private var setNumber: Int = 1
    @State private var timeRemaining: Int = 3
    @State private var percent: Double = 0
    @State private var title: String = "Get Ready!"
    @State private var isPresented: Bool = false
    @State private var displayMode: DisplayMode = .energy
    @State private var showingAlert: Bool = false
    @State private var alertType: Int = 0
    
    @FetchRequest(entity: Record.entity(), sortDescriptors: []) var fetchedResults: FetchedResults<Record>
    
    var CDRecord: Record? {
        fetchedResults.first(where: {$0.id == exercise.id})
    }
    
    enum DisplayMode {
        case energy, heartRate
    }
    
    var quantity: String {
        switch displayMode {
        case .energy:
            return String(format: "%.0f", dataManager.totalEnergyBurned)
        case .heartRate:
            return String(Int(dataManager.lastHeartRate))
        }
    }
    
    var unit: String {
        switch displayMode {
        case .energy:
            return "calories"
        case .heartRate:
            return "beats / minute"
        }
    }
    
    func changeDisplayMode() {
        switch displayMode {
        case .energy:
            displayMode = .heartRate
        case .heartRate:
            displayMode = .energy
        }
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
    
    func saveWorkout(CDRecordTotal: Int64) {
        if CDRecordTotal == 0 {
            //create new Record
            alertType = 1
            let newRecord = Record(context: dataController.container.viewContext)
            newRecord.id = exercise.id
            newRecord.set1 = Int64(record[1]!)
            newRecord.set2 = Int64(record[2]!)
            newRecord.set3 = Int64(record[3]!)
            newRecord.calories = Int64(dataManager.totalEnergyBurned)
            print("saving new record")
            dataController.save()
            isPresented = true
        } else {
            // update existing record
            if record[1]! + record[2]! + record[3]! > CDRecordTotal {
                alertType = 2
                CDRecord?.set1 = Int64(record[1]!)
                CDRecord?.set2 = Int64(record[2]!)
                CDRecord?.set3 = Int64(record[3]!)
                CDRecord?.calories = Int64(dataManager.totalEnergyBurned)
                print("preparing update your record")
                dataController.save()
                isPresented = true
            } else {
                // didnt beat your record
                alertType = 3
                isPresented = true
            }
        }
    }
    
    var body: some View {
        VStack {
            if setNumber < 4 {
                if timeRemaining > -1 {
                    TimedRing(totalSeconds: setNumber == 1 ? 3 : 120, percent: $percent, timeRemaining: $timeRemaining)
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
                        title = "Set \(setNumber)"
                        if setNumber == 1 {
                            dataManager.start()
                        } else {
                            dataManager.resume()
                        }
                    }
                    Spacer()
                    
                    VStack {
                        Group {
                            Text(quantity).font(.largeTitle)
                            Text(unit).textCase(.uppercase)
                        }.onTapGesture(perform: changeDisplayMode)
                    }
                    Spacer()
                    Button("Done") {
                        record[setNumber] = Int(setValue)
                        title = "Rest"
                        timeRemaining = 120
                        setNumber += 1
                        percent = 0
                        dataManager.pause()
                    }
                }
            } else {
                Form {
                    Section(header: Text("Reps per set")) {
                        HStack {
                            Text("Set 1:")
                            Spacer()
                            Text("\(record[1] ?? 0)")
                        }
                        HStack {
                            Text("Set 2:")
                            Spacer()
                            Text("\(record[2] ?? 0)")
                        }
                        HStack {
                            Text("Set 3:")
                            Spacer()
                            Text("\(record[3] ?? 0)")
                        }
                    }
                    Section(header: Text("Total")) {
                        HStack {
                            Text("Total sum:")
                            Spacer()
                            Text("\((record[1] ?? 0) + (record[2] ?? 0) + (record[3] ?? 0))")
                        }
                    }
                    Section(header: Text("Colories")) {
                        HStack {
                            Text("Total burned:")
                            Spacer()
                            Text("\(Int(dataManager.totalEnergyBurned))")
                        }
                    }
                    Button("SAVE") {
                        dataManager.end()
                        saveWorkout(CDRecordTotal: getRecord(CDRecord: CDRecord, exerciseId: exercise.id))
                    }.foregroundColor(.green)
                }.onAppear {
                    title = "Summary"
                }
            }
        }
        .navigationTitle(title)
        .alert(isPresented: $isPresented) { () -> Alert in
            Alert(
                title: createAlertTile(type: alertType),
                message: createAlertBody(
                    type: alertType,
                    CDRecord: CDRecord!.set1 + CDRecord!.set2 + CDRecord!.set3,
                    currentRecord: record[1]! + record[2]! + record[3]!
                ),
                dismissButton: .default(Text("Ok"), action: {
                    presentation.wrappedValue.dismiss()
                })
            )
        }
    }
}
