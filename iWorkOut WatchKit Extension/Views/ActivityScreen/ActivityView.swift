import SwiftUI
import UserNotifications

struct ActivityView: View {

    // MARK: - Properties and States

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
                Summary()
                    .environmentObject(viewModel)
                    .onAppear {
                        viewModel.title = "Summary"
                        viewModel.dataManager.end()
                    }
            }
        }
        .navigationTitle(viewModel.title)
        .onReceive(
            NotificationCenter.default.publisher(for: WKExtension.applicationWillResignActiveNotification),
            perform: { _ in movingToBackground() }
        )
        .onReceive(
            NotificationCenter.default.publisher(for: WKExtension.applicationDidBecomeActiveNotification),
            perform: { _ in movingToForeground() }
        )
    }

    // MARK: - Helper functions

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
