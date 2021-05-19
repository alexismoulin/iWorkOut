import SwiftUI

struct IconView: View {
    let size: CGFloat
    let displayMode: DisplayMode
    var body: some View {
        switch displayMode {
        case .energy:
            return Image(systemName: "flame")
                .resizable()
                .scaledToFit()
                .foregroundColor(.orange)
                .frame(width: 16 * size)
        case .heartRate:
            return Image(systemName: "heart")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
                .frame(width: 16 * size)
        case .time:
            return Image(systemName: "timer")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 16 * size)
        case .oxygenSaturation:
            // not used yet
            return Image(systemName: "lungs")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(width: 16 * size)
        }
    }
}
