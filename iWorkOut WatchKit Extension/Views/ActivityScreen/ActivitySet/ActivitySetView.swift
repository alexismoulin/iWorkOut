import SwiftUI

struct ActivitySetView: View {

    @EnvironmentObject var viewModel: ActivityViewModel
    @EnvironmentObject var stopWatchManager: StopWatchManager

    @State private var displayMode: DisplayMode = .energy
    @State private var weight: Double = 0

    // MARK: - Components

    var healthMonitor: some View {
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
    }

    var doneButton: some View {
        Button("DONE") {
            viewModel.record[viewModel.setNumber] = Int(viewModel.value)
            viewModel.title = "Rest"
            viewModel.timeRemaining = 120
            viewModel.setNumber += 1
            viewModel.percent = 0
            viewModel.dataManager.pause() // pause dataManager
            stopWatchManager.stop() // stops stopWatch
        }
    }

    // MARK: - Body

    var body: some View {
        VStack {
            ActivityRepsView()
            Spacer()
            healthMonitor
            Spacer()
            doneButton
        }
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
}
