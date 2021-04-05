import SwiftUI
import UserNotifications

struct ActivityView: View {

    let exercise: Exercise

    // MARK: - Environment variables

    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentation

    // MARK: - States

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

    // MARK: - CoreData functions and variables

    @FetchRequest(entity: Record.entity(), sortDescriptors: []) var fetchedResults: FetchedResults<Record>

    var CDRecord: Record? {
        fetchedResults.first(where: {$0.id == exercise.id})
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

    // MARK: - HealthKit functions and variables

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

    // MARK: - Custom User Notifications

    func movingToBackground() {
        print("Moving to the background")
        notificationDate = Date()
        // StopWatchManager timer only
        if timeRemaining == -1 {
            stopWatchManager.pause()
        }
    }

    func movingToForeground() {
        print("Moving to the foreground")
        let deltaTime: Int = Int(Date().timeIntervalSince(notificationDate))
        if timeRemaining > -1 {
            timeRemaining -= deltaTime
            percent += Double(deltaTime) / 1.2
        } else {
            stopWatchManager.secondsElapsed += deltaTime
            stopWatchManager.start()
        }
    }

    // MARK: - components functions

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
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(isFocused ? Color.green : Color.gray, lineWidth: 2))
        }
    }

    func createSetActivity() -> some View {
        VStack {
            createReps()
            Spacer()
            Group {
                Text(dataManager.quantity(displayMode: displayMode, stopWatchManager: stopWatchManager))
                    .font(.largeTitle)
                Text(dataManager.unit(displayMode: displayMode))
                    .textCase(.uppercase)
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
                saveWorkout(CDRecordTotal: Record.getRecord(CDRecord: CDRecord, exerciseId: exercise.id))
            }
            .foregroundColor(.green)
        }
    }

    // MARK: - Main body

    var body: some View {
        VStack {
            if correction {
                createCorrection()
            } else {
                if setNumber < 4 {
                    if timeRemaining > -1 {
                        TimedRing(
                            totalSeconds: setNumber == 1 ? 3 : 120,
                            percent: $percent,
                            timeRemaining: $timeRemaining
                        )
                            .gesture(
                                DragGesture(minimumDistance: 50, coordinateSpace: .local)
                                    .onEnded { _ in
                                        backScreen()
                                    }
                            )
                    } else {
                        createSetActivity()
                            .onAppear(perform: setupSet)
                    }
                } else {
                    createSummary()
                        .onAppear { title = "Summary" }
                        // see for extract custom gesture
                        .gesture(
                            DragGesture(minimumDistance: 50, coordinateSpace: .local)
                                .onEnded { _ in
                                    backScreen()
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
        .onReceive(NotificationCenter.default.publisher(
                    for: WKExtension.applicationWillResignActiveNotification
        )) { _ in
            movingToBackground()
        }
        .onReceive(NotificationCenter.default.publisher(
                    for: WKExtension.applicationDidBecomeActiveNotification
        )) { _ in
            movingToForeground()
        }
        .onAppear(perform: requestPermission)
    }

    // MARK: - Helper functions

    func backScreen() {
        if setNumber > 1 {
            setNumber -= 1
            title = "Set \(setNumber)"
            correction = true
        }
    }

    func setupSet() {
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
