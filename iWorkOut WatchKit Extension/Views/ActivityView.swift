import SwiftUI
import UserNotifications

struct ActivityView: View {

    // MARK: - Properties and States

    @Environment(\.presentationMode) var presentation

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
    @StateObject private var viewModel: ViewModel

    // MARK: - Custom init

    init(dataController: DataController, dataManager: DataManager, exercise: Exercise) {
        let viewModel = ViewModel(dataController: dataController, dataManager: dataManager, exercise: exercise)
        _viewModel = StateObject(wrappedValue: viewModel)
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
        switch viewModel.exercise.type {
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
                    through: viewModel.exercise.type != "time" ? 100 : 1000,
                    by: viewModel.exercise.type != "time" ? 1 : 5,
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
                Text(viewModel.dataManager.quantity(displayMode: displayMode, stopWatchManager: stopWatchManager))
                    .font(.largeTitle)
                Text(viewModel.dataManager.unit(displayMode: displayMode))
                    .textCase(.uppercase)
            }.onTapGesture(perform: changeDisplayMode)
            Spacer()
            Button("Done") {
                record[setNumber] = Int(setValue)
                title = "Rest"
                timeRemaining = 120
                setNumber += 1
                percent = 0
                viewModel.dataManager.pause() // pause dataManager
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
                    Text("\(Int(viewModel.dataManager.totalEnergyBurned))")
                }
            }
            Button("SAVE") {
                viewModel.dataManager.end()
                saveWorkout(
                    CDRecordTotal: Record.getRecord(CDRecord: viewModel.CDRecord, exerciseId: viewModel.exercise.id)
                )
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
                CDRecordSum: viewModel.CDRecord!.set1 + viewModel.CDRecord!.set2 + viewModel.CDRecord!.set3,
                currentRecordSum: record[1]! + record[2]! + record[3]!,
                dismissfunction: { presentation.wrappedValue.dismiss() }
            )
        }
        .onReceive(
            NotificationCenter.default.publisher(for: WKExtension.applicationWillResignActiveNotification),
            perform: { _ in
                movingToBackground()
            }
        )
        .onReceive(
            NotificationCenter.default.publisher(for: WKExtension.applicationDidBecomeActiveNotification),
            perform: { _ in
                movingToForeground()
            }
        )
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
            viewModel.dataManager.start() // start dataManager
            stopWatchManager.start()
        } else {
            viewModel.dataManager.resume() // resume dataManager
            stopWatchManager.start()
        }
    }

    func createNewRecord() {
        alertType = 1
        viewModel.createNewRecord(record: record)
        isPresented = true
    }

    func updateExistingRecord() {
        alertType = 2
        viewModel.updateExistingRecord(record: record)
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
}
