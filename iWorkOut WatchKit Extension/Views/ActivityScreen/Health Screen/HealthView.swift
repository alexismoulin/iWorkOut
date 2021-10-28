import SwiftUI

struct HealthView: View {

    @EnvironmentObject var viewModel: ActivityViewModel
    @EnvironmentObject var stopWatchManager: StopWatchManager

    @State private var displayMode: DisplayMode = .energy
    @State private var weight: Double = 0

    // MARK: - Components

    func createHealthMonitor(displayMode: DisplayMode) -> some View {
        HStack {
            IconView(size: 2, displayMode: displayMode)
            Text(viewModel.dataManager.quantity(displayMode: displayMode, stopWatchManager: stopWatchManager))
                .font(.title)
            Text(viewModel.dataManager.unit(displayMode: displayMode))
                .textCase(.uppercase)
        }
    }

    private var doneButton: some View {
        Button("DONE") {
            viewModel.dataManager.pause() // pause dataManager
            stopWatchManager.stop() // stops stopWatch
            viewModel.screenType = .setInfo
        }
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
        VStack(alignment: .leading, spacing: 0) {
            createHealthMonitor(displayMode: .heartRate)
            createHealthMonitor(displayMode: .energy)
            createHealthMonitor(displayMode: .time)
            Spacer()
            doneButton
        }
        }.onAppear(perform: setupSet)
    }

    // MARK: - Helper functions

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

    func setupSet() {
        viewModel.title = "Set \(viewModel.setNumber)"
        if viewModel.setNumber == 1 {
            viewModel.dataManager.start() // start dataManager
            stopWatchManager.start()
        } else {
            viewModel.dataManager.resume() // resume dataManager
            stopWatchManager.start()
        }
    }
}
