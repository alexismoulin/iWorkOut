import SwiftUI

// Not used
class StopWatchManager: ObservableObject {
    @Published var secondsElapsed: Int = 0
    var timer: Timer = Timer()

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.secondsElapsed += 1
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
