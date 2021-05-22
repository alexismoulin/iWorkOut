import SwiftUI

struct RoundedRectangleView: View {
    let leftText: String
    let rightText: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8).foregroundColor(.gray.opacity(0.2))
            HStack {
                Text(leftText)
                Spacer()
                Text(rightText)
            }.padding()
        }
    }
}
