import SwiftUI

struct TimedRing: View {

    @EnvironmentObject var viewModel: ActivityViewModel
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var totalSeconds: Double {
        viewModel.setNumber == 1 ? 3 : 120
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            PercentageRing(
                ringWidth: 20, percent: viewModel.percent,
                backgroundColor: Color.green.opacity(0.2),
                foregroundColors: [.green, .blue]
            )
            VStack {
                Text("\(viewModel.timeRemaining)")
                    .font(.largeTitle)
                Text("Long Press")
                    .font(.system(size: 12))
                Text("to skip")
                    .font(.system(size: 12))
            }
            .onLongPressGesture {
                viewModel.timeRemaining = 0
                viewModel.percent = 100
            }
            .onReceive(timer) { _ in
                manageTimer()
            }
        }
    }

    // MARK: - Helper functions

    func manageTimer() {
        if viewModel.timeRemaining > -1 {
            viewModel.timeRemaining -= 1
            withAnimation {
                viewModel.percent += 100 / totalSeconds
            }
        }
        if viewModel.timeRemaining == 0 {
            WKInterfaceDevice.current().play(.start)
            timer.upstream.connect().cancel()
        }
        if viewModel.timeRemaining < 0 {
            if viewModel.setNumber < 4 {
                viewModel.screenType = .health
            }
            if viewModel.setNumber > 3 {
                viewModel.screenType = .summary
            }
        }
    }

}
