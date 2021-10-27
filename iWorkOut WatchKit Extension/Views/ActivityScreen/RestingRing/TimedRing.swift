import SwiftUI

struct TimedRing: View {

    @EnvironmentObject var viewModel: ActivityViewModel
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let totalSeconds: Double

    // MARK: - Body
    var body: some View {
        ZStack {
            PercentageRing(
                ringWidth: 20, percent: viewModel.percent,
                backgroundColor: Color.green.opacity(0.2),
                foregroundColors: [.green, .blue]
            )
            Text("\(viewModel.timeRemaining)")
                .font(.largeTitle)
                .onLongPressGesture {
                    viewModel.timeRemaining = 0
                    viewModel.percent = 100
                }
                .onReceive(timer) { _ in
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
                }
        }
    }

}
