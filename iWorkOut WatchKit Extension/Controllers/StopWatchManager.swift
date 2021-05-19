import SwiftUI

class StopWatchManager: ObservableObject {
    @Published var secondsElapsed: Double = 0
    var timer: Timer = Timer()

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.secondsElapsed += 0.1
        }
    }

    func stop() {
        timer.invalidate()
        secondsElapsed = 0
    }

    func pause() {
        timer.invalidate()
    }
}
