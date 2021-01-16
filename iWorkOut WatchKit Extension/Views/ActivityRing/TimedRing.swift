import SwiftUI

struct TimedRing: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let totalSeconds: Double
    @Binding var percent: Double
    @Binding var timeRemaining: Int
    var body: some View {
        ZStack {
            PercentageRing(
                ringWidth: 20, percent: percent,
                backgroundColor: Color.green.opacity(0.2),
                foregroundColors: [.green, .blue]
            )
            Text("\(timeRemaining)")
                .font(.largeTitle)
                .onTapGesture {
                    timeRemaining = 0
                    percent = 100
                }
                .onReceive(timer) { _ in
                    if timeRemaining > -1 {
                        timeRemaining -= 1
                        withAnimation {
                            percent += 100 / totalSeconds
                        }
                    }
                    if timeRemaining == 0 {
                        WKInterfaceDevice.current().play(.start)
                    }
                }
        }
    }
}


