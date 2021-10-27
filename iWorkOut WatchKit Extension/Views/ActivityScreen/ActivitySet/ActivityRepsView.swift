import SwiftUI

struct ActivityRepsView: View {

    @EnvironmentObject var viewModel: ActivityViewModel
    @State private var isFocused: Bool = false
    @State private var variable: Double = 10

    var type: String {
        switch viewModel.exercise.type {
        case "rep":
            return "Reps:"
        case "duration":
            return "Duration"
        default:
            return "Error!"
        }
    }

    var body: some View {
        HStack {
            Text(type)
            Spacer()
            Image(systemName: "plus.square")
            Text("\(Int(viewModel.value))")
                .padding()
                .frame(width: 50)
                .contentShape(Rectangle())
                .focusable { isFocused = $0 }
                .digitalCrownRotation(
                    $viewModel.value,
                    from: 0,
                    through: type != "Duration(s)" ? 100 : 600,
                    by: type != "Duration(s)" ? 1 : 5,
                    sensitivity: type != "Duration(s)" ? .low : .medium,
                    isContinuous: false,
                    isHapticFeedbackEnabled: true
                )
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(isFocused ? Color.green : Color.gray, lineWidth: 2))
            Image(systemName: "minus.square")
        }
    }
}
