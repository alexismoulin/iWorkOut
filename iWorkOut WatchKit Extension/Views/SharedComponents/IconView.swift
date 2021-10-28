import SwiftUI

struct IconView: View {
    let size: CGFloat?
    let displayMode: DisplayMode

    var ajustedSize: CGFloat {
        guard let size = size else { return .infinity }
        return 16 * size
    }

    var body: some View {
        switch displayMode {
        case .energy:
            return Image(systemName: "flame")
                .resizable()
                .scaledToFit()
                .foregroundColor(.orange)
                .frame(width: ajustedSize)
        case .heartRate:
            return Image(systemName: "heart")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
                .frame(width: ajustedSize)
        case .time:
            return Image(systemName: "timer")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: ajustedSize)
        case .oxygenSaturation:
            // not used yet
            return Image(systemName: "lungs")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(width: ajustedSize)
        }
    }
}
