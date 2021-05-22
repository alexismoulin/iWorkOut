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

    @StateObject private var viewModel: ViewModel
    @StateObject private var stopWatchManager = StopWatchManager()

    // MARK: - Custom init

    init(dataController: DataController, dataManager: DataManager, exercise: Exercise, fetchedRecord: Record?) {
        let viewModel = ViewModel(
            dataController: dataController,
            dataManager: dataManager,
            exercise: exercise,
            fetchedRecord: fetchedRecord
        )
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - components functions

    func createReps() -> some View {
        var type: String
        switch viewModel.exercise.type {
        case "rep":
            type = "Reps:"
        case "time":
            type = "Duration(s)"
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
                    through: 100,
                    by: 1,
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
            HStack {
                IconView(size: 3, displayMode: displayMode)
                    .padding(.leading, 20)
                Spacer()
                VStack {
                    Text(viewModel.dataManager.quantity(displayMode: displayMode, stopWatchManager: stopWatchManager))
                        .font(.largeTitle)
                    Text(viewModel.dataManager.unit(displayMode: displayMode))
                        .textCase(.uppercase)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: changeDisplayMode)
            Spacer()
            Button("Done") {
                record[setNumber] = Int(setValue)
                title = "Rest"
                timeRemaining = 120
                setNumber += 1
                percent = 0
                viewModel.dataManager.pause() // pause dataManager
                stopWatchManager.stop() // stops stopWatch
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
            SummaryView(
                set1Value: record[1] ?? 0,
                set2Value: record[2] ?? 0,
                set3Value: record[3] ?? 0,
                calories: Int(viewModel.dataManager.totalEnergyBurned),
                heartRate: calculateBPM()
            )
            Button("SAVE") {
                viewModel.dataManager.end()
                saveWorkout(CDRecordTotal: Record.getRecord(
                    CDRecord: viewModel.fetchedRecord,
                    exerciseId: viewModel.exercise.id
                ))
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
                        .onAppear {
                            title = "Summary"
                            viewModel.dataManager.end()
                        }
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
                CDRecordSum: viewModel.fetchedRecord?.sum ?? 0,
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

    func calculateBPM() -> Int {
        let sumBPM: Double =  viewModel.dataManager.heartRateValues.reduce(0, +)
        let sumMeasurements: Double = Double(viewModel.dataManager.heartRateValues.count)
        if sumMeasurements == 0 {
            return 0
        } else {
            return Int(sumBPM / sumMeasurements)
        }
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
        case .oxygenSaturation:
            displayMode = .energy
        case .time:
            displayMode = .energy
        }
    }

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
        let deltaTime: Double = Date().timeIntervalSince(notificationDate)
        if timeRemaining > -1 {
            timeRemaining -= Int(deltaTime)
            percent += deltaTime / 1.2
        } else {
            stopWatchManager.secondsElapsed += deltaTime
            stopWatchManager.start()
        }
    }
}
