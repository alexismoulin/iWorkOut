import SwiftUI

struct SetInfoView: View {

    // MARK: - Properties

    @EnvironmentObject var viewModel: ActivityViewModel
    @State private var isFocused: Bool = false
    @State private var variable: Double = 10
    @State private var weight: Double = 0
    @State private var reps: Double = 0

    var valueSaved: Int {
        Int(reps * weight)
    }

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

    // MARK: - Components

    private var doneButton: some View {
        Button {
            viewModel.record[viewModel.setNumber] = valueSaved
            viewModel.title = "Rest"
            viewModel.timeRemaining = 120
            viewModel.percent = 0
            viewModel.setNumber += 1
            viewModel.screenType = .recover
        } label: {
            HStack {
                Text("Next set").bold()
                Image(systemName: "forward.fill")
            }.foregroundColor(.lime)
        }
    }

    private var weightSlider: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: "square.stack.3d.up.fill")
                    Text("Weight").font(.system(size: 12)).padding(2)
                }
                Spacer()
                Text("**\(Int(weight))** kg").font(.system(size: 14)).padding(0)
            }
            Slider(value: $weight, in: 0...100, step: 5).tint(.yellow2)
        }
    }

    private var repsSlider: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: "arrow.clockwise.heart.fill")
                    Text("Set of").font(.system(size: 12)).padding(2)
                }
                Spacer()
                Text("**\(Int(reps))** reps").font(.system(size: 14)).padding(0)
            }
            Slider(value: $reps, in: 0...20, step: 1).tint(.purple)
        }
    }

    private var textLabel: some View {
        Group {
            Text("\(Int(reps))")
                .bold()
                .foregroundColor(.purple) +
            Text(" x ") +
            Text("\(Int(weight))")
                .bold()
                .foregroundColor(.yellow2) +
            Text(" kg = **\(valueSaved)** kg")
        }
    }

    // MARK: - body

    var body: some View {
        ScrollView {
            VStack {
                repsSlider
                weightSlider
                Divider()
                textLabel
                Spacer(minLength: 15)
                doneButton
            }
        }
    }
}
