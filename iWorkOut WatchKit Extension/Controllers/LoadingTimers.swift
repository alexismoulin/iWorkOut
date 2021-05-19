import SwiftUI
import Combine

class AnimatedImageTimer {

    let publisher = Timer.publish(every: 0.5, on: .main, in: .default)
    private var timerCancellable: Cancellable?

    func start() {
        timerCancellable = publisher.connect()
    }

    func cancel() {
        timerCancellable?.cancel()
    }
}

class StopWatchTimer {

    let publisher = Timer.publish(every: 0.1, on: .main, in: .default)
    private var timerCancellable: Cancellable?

    func start() {
        timerCancellable = publisher.connect()
    }

    func cancel() {
        timerCancellable?.cancel()
    }
}
