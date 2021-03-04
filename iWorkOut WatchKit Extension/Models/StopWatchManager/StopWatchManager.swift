import SwiftUI

class StopWatchManager: ObservableObject {
    @Published var secondsElapsed: Int = 0
    var timer: Timer = Timer()
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            self.secondsElapsed += 5
        }
    }
    
    func stop() {
        timer.invalidate()
        secondsElapsed = 0
    }
}
