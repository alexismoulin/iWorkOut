import SwiftUI

class StopWatchManager: ObservableObject {
    @Published var secondsElapsed: Int = 0
    var timer: Timer = Timer()
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
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
