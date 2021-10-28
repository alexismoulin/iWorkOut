import SwiftUI

struct HealthView: View {

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

    private var doneButton: some View {
        Button("DONE") {
            viewModel.dataManager.pause() // pause dataManager
            stopWatchManager.stop() // stops stopWatch
            viewModel.screenType = .setInfo
        }
    }

    // MARK: - Body

    var body: some View {
        VStack {
            healthMonitor
                .padding(.top, 5)
            Spacer()
            doneButton
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
