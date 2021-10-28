import SwiftUI
import UserNotifications

struct ActivityView: View {

    // MARK: - Properties and States

    @Environment(\.presentationMode) var presentation

    @State private var isPresented: Bool = false
    @State private var showingAlert: Bool = false
    @State private var alertType: Int = 0
    @State private var notificationDate: Date = Date()

    @StateObject private var viewModel: ActivityViewModel
    @StateObject private var stopWatchManager = StopWatchManager()

    // MARK: - Custom init

    init(dataController: DataController, dataManager: DataManager, exercise: Exercise, fetchedRecord: Record?) {
        let viewModel = ActivityViewModel(
            dataController: dataController,
            dataManager: dataManager,
            exercise: exercise,
            fetchedRecord: fetchedRecord
        )
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - components functions

    var summary: some View {
        Form {
            SummaryView(
                set1Value: viewModel.record[1] ?? 0,
                set2Value: viewModel.record[2] ?? 0,
                set3Value: viewModel.record[3] ?? 0,
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
            switch viewModel.screenType {
            case .recover:
                TimedRing()
                    .environmentObject(viewModel)
            case .health:
                HealthView()
                    .environmentObject(viewModel)
                    .environmentObject(stopWatchManager)
            case .setInfo:
                SetInfoView()
                    .environmentObject(viewModel)
            case .summary:
                summary
                    .environmentObject(viewModel)
                    .onAppear {
                        viewModel.title = "Summary"
                        viewModel.dataManager.end()
                    }
            }
        }
        .navigationTitle(viewModel.title)
        .alert(isPresented: $isPresented) {
            createCustomAlert(
                alertType: alertType,
                CDRecordSum: viewModel.fetchedRecord?.sum ?? 0,
                currentRecordSum: viewModel.record[1]! + viewModel.record[2]! + viewModel.record[3]!,
                dismissfunction: { presentation.wrappedValue.dismiss() }
            )
        }
        .onReceive(
            NotificationCenter.default.publisher(for: WKExtension.applicationWillResignActiveNotification),
            perform: { _ in movingToBackground() }
        )
        .onReceive(
            NotificationCenter.default.publisher(for: WKExtension.applicationDidBecomeActiveNotification),
            perform: { _ in movingToForeground() }
        )
        .onAppear(perform: requestPermission)
    }

    // MARK: - Helper functions

    func createNewRecord() {
        alertType = 1
        viewModel.createNewRecord(record: viewModel.record)
        isPresented = true
    }

    func updateExistingRecord() {
        alertType = 2
        viewModel.updateExistingRecord(record: viewModel.record)
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
            if viewModel.record[1]! + viewModel.record[2]! + viewModel.record[3]! > CDRecordTotal {
                updateExistingRecord()
            } else {
                failedBeatRecord()
            }
        }
    }

    func movingToBackground() {
        print("Moving to the background")
        notificationDate = Date()
        // StopWatchManager timer only
        if viewModel.timeRemaining == -1 {
            stopWatchManager.pause()
        }
    }

    func movingToForeground() {
        print("Moving to the foreground")
        let deltaTime: Double = Date().timeIntervalSince(notificationDate)
        if viewModel.timeRemaining > -1 {
            viewModel.timeRemaining -= Int(deltaTime)
            viewModel.percent += deltaTime / 1.2
        } else {
            stopWatchManager.secondsElapsed += deltaTime
            stopWatchManager.start()
        }
    }
}
