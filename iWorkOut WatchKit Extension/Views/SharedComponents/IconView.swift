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
                .frame(height: 16 * size)
        case .heartRate:
            return Image(systemName: "heart")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
                .frame(height: 16 * size)
        case .oxygenSaturation:
            return Image(systemName: "lungs")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(height: 16 * size)
        }
    }
}
