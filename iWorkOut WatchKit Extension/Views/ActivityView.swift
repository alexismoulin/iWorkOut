import SwiftUI
import UserNotifications

struct ActivityView: View {
    
    let exercise: Exercise
    
    //MARK: - Environment variables
    
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentation
    
    //MARK: - States
    
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
    @State private var notificationDate: Date = Date()
    @State private var correction: Bool = false
    
    @StateObject private var stopWatchManager = StopWatchManager()
    
    //MARK: - CoreData functions and variables
    
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
    
    func createNewRecord() {
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
    }
    
    func updateExistingRecord() {
        alertType = 2
        CDRecord?.set1 = Int64(record[1]!)
        CDRecord?.set2 = Int64(record[2]!)
        CDRecord?.set3 = Int64(record[3]!)
        CDRecord?.calories = Int64(dataManager.totalEnergyBurned)
        print("preparing update your record")
        dataController.save()
        isPresented = true
    }
    
    func failedBeatRecord() {
        alertType = 3
        isPresented = true
    }
    
    func saveWorkout(CDRecordTotal: Int64) {
        if CDRecordTotal == 0 {
           createNewRecord()
        } else {
            if record[1]! + record[2]! + record[3]! > CDRecordTotal {
                updateExistingRecord()
            } else {
                failedBeatRecord()
            }
        }
    }
    
    //MARK: - HealthKit functions and variables
    
    enum DisplayMode {
        case energy, heartRate, time
    }
    
    var quantity: String {
        switch displayMode {
        case .energy:
            return String(format: "%.0f", dataManager.totalEnergyBurned)
        case .heartRate:
            return String(Int(dataManager.lastHeartRate))
        case .time:
            return String(stopWatchManager.secondsElapsed)
        }
    }
    
    var unit: String {
        switch displayMode {
        case .energy:
            return "calories"
        case .heartRate:
            return "beats / minute"
        case .time:
            return "seconds"
        }
    }
    
    func changeDisplayMode() {
        switch displayMode {
        case .energy:
            displayMode = .heartRate
        case .heartRate:
            displayMode = .time
        case .time:
            displayMode = .energy
        }
    }
    
    //MARK: - User Notifications
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Rest time is over"
        content.subtitle = "Be ready for the next set"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    //MARK: - components functions
    
    func createReps() -> some View {
        var type: String
        switch exercise.type {
        case "rep":
            type = "Reps:"
        case "time":
            type = "Time(s)"
        default:
            type = "Error"
        }

        return HStack {
            Text(type)
            Spacer()
            Text("\(Int(setValue))")
                .padding()
                .frame(width: 50)
                .contentShape(Rectangle())
                .focusable { isFocused = $0 }
                .digitalCrownRotation(
                    $setValue,
                    from: 0,
                    through: exercise.type != "time" ? 100 : 1000,
                    by: exercise.type != "time" ? 1 : 5,
                    sensitivity: .low,
                    isContinuous: false,
                    isHapticFeedbackEnabled: true
                )
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(isFocused ? Color.green : Color.gray, lineWidth: 2))
        }
    }
    
    func createSetActivity() -> some View {
        VStack {
            createReps()
            Spacer()
            Group {
                Text(quantity).font(.largeTitle)
                Text(unit).textCase(.uppercase)
            }.onTapGesture(perform: changeDisplayMode)
            Spacer()
            Button("Done") {
                record[setNumber] = Int(setValue)
                title = "Rest"
                timeRemaining = 120
                setNumber += 1
                percent = 0
                dataManager.pause() // pause dataManager
                stopWatchManager.stop()
            }
        }
    }
    
    func createCorrection() -> some View {
        VStack {
            createReps()
            Spacer()
            Button("Correction") {
                record[setNumber] = Int(setValue)
                title = "Rest"
                setNumber += 1
                correction = false
            }
        }
    }
    
    func createSummary() -> some View {
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
            }
            .foregroundColor(.green)
        }
    }
    
    func createTimedRing() -> some View {
        let totalSeconds: Double = setNumber == 1 ? 3 : 120
        return TimedRing(totalSeconds: totalSeconds, percent: $percent, timeRemaining: $timeRemaining)
    }
    
    //MARK: - Main body
    
    var body: some View {
        VStack {
            if correction {
                createCorrection()
            } else {
                if setNumber < 4 {
                    if timeRemaining > -1 {
                        TimedRing(totalSeconds: setNumber == 1 ? 3 : 120, percent: $percent, timeRemaining: $timeRemaining)
                            .gesture(
                                DragGesture(minimumDistance: 50, coordinateSpace: .local)
                                    .onEnded { _ in
                                        if setNumber > 1 {
                                            setNumber -= 1
                                            title = "Set \(setNumber)"
                                            correction = true
                                        }
                                    }
                            )
                    } else {
                        createSetActivity()
                            .onAppear {
                                title = "Set \(setNumber)"
                                if setNumber == 1 {
                                    dataManager.start() // start dataManager
                                    stopWatchManager.start()
                                } else {
                                    dataManager.resume() // resume dataManager
                                    stopWatchManager.start()
                                }
                            }
                    }
                } else {
                    createSummary()
                        .onAppear {
                            title = "Summary"
                        }
                        .gesture(
                            DragGesture(minimumDistance: 50, coordinateSpace: .local)
                                .onEnded { _ in
                                    setNumber -= 1
                                    title = "Set \(setNumber)"
                                    correction = true
                                }
                        )
                }
            }
        }
        .navigationTitle(title)
        .alert(isPresented: $isPresented) {
            createCustomAlert(
                alertType: alertType,
                CDRecordSum: CDRecord!.set1 + CDRecord!.set2 + CDRecord!.set3,
                currentRecordSum: record[1]! + record[2]! + record[3]!,
                dismissfunction: { presentation.wrappedValue.dismiss() }
            )
        }
        .onReceive(NotificationCenter.default.publisher(for: WKExtension.applicationWillResignActiveNotification)) { _ in
            print("Moving to the background")
            notificationDate = Date()
            scheduleNotification()
            stopWatchManager.pause()
        }
        .onReceive(NotificationCenter.default.publisher(for: WKExtension.applicationDidBecomeActiveNotification)) { _ in
            print("Moving to the foreground")
            let deltaTime: Int = Int(Date().timeIntervalSince(notificationDate))
            timeRemaining -= deltaTime
            percent += Double(deltaTime) / 1.2
            stopWatchManager.secondsElapsed += deltaTime
            stopWatchManager.start()
        }
        .onAppear(perform: requestPermission)
    }
}
