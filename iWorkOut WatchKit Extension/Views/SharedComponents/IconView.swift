import SwiftUI

struct IconView: View {
    let size: CGFloat
    let displayMode: DisplayMode
    var body: some View {
        switch displayMode {
        case .energy:
            return AnyView(FlameView(size: size))
        case .heartRate:
            return AnyView(HeartView(size: size))
        case .time:
            return AnyView(TimerView(size: size))
        }
    }
}

struct FlameView: View {
    let size: CGFloat

    var body: some View {
        Image(systemName: "flame")
            .resizable()
            .scaledToFit()
            .foregroundColor(.orange)
            .frame(height: 16 * size)
    }
}

struct CrownView: View {
    let size: CGFloat

    var body: some View {
        Image(systemName: "crown")
            .resizable()
            .scaledToFit()
            .foregroundColor(.yellow)
            .frame(height: 16 * size)
    }
}

struct TimerView: View {
    let size: CGFloat

    var body: some View {
        Image(systemName: "timer")
            .resizable()
            .scaledToFit()
            .foregroundColor(.white)
            .frame(height: 16 * size)
    }
}

struct HeartView: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Image(systemName: "heart")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
                .frame(height: 16 * size)
            Image(systemName: "waveform.path.ecg")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
                .frame(height: 15 * size)
        }
    }
}
