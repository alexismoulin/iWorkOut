import SwiftUI

struct SetInfoView: View {

    // MARK: - Properties

    @EnvironmentObject var viewModel: ActivityViewModel

    @State private var weight: Double = 0
    @State private var reps: Double = 0
    @State private var duration: Double = 0

    var valueSaved: Int {
        switch viewModel.exercise.type {
        case "rep":
            return Int(reps)
        case "weight":
            return Int(reps * weight)
        case "duration":
            return Int(duration)
        default:
            return 0
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
                HStack(spacing: 6) {
                    Image(systemName: "square.stack.3d.up.fill")
                    Text("Weight")
                        .font(.system(size: 12))
                        .padding(2)
                }
                Text("\(Int(weight))")
                    .font(.system(size: 14))
                    .bold()
                    .foregroundColor(.yellow2) +
                Text(" kg")
                    .font(.system(size: 14))
            }
            Slider(value: $weight, in: 0...100, step: 5).tint(.yellow2)
        }
    }

    private var repsSlider: some View {
        ZStack {
            VStack(spacing: 6) {
                HStack {
                    Image(systemName: "arrow.clockwise.heart.fill")
                    Text("Set of")
                        .font(.system(size: 12))
                        .padding(2)
                }
                Text("\(Int(reps))")
                    .font(.system(size: 14))
                    .bold()
                    .foregroundColor(.purple) +
                Text(" reps")
                    .font(.system(size: 14))
            }
            Slider(value: $reps, in: 0...20, step: 1).tint(.purple)
        }
    }

    private var durationSlider: some View {
        ZStack {
            VStack(spacing: 6) {
                HStack {
                    Image(systemName: "timer")
                    Text("Duration of")
                        .font(.system(size: 12))
                        .padding(2)
                }
                Text("\(Int(duration))")
                    .font(.system(size: 14))
                    .bold()
                    .foregroundColor(.blue) +
                Text(" seconds")
                    .font(.system(size: 14))
            }
            Slider(value: $duration, in: 0...100, step: 5).tint(.blue)
        }
    }

    private var weightTextLabel: some View {
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

    private var weightView: some View {
        ScrollView {
            repsSlider
            weightSlider
            Divider()
            weightTextLabel
            Spacer(minLength: 15)
            doneButton
        }
    }

    private var repsView: some View {
        VStack {
            repsSlider
            Spacer()
            doneButton
        }
    }

    private var durationView: some View {
        VStack {
            durationSlider
            Spacer()
            doneButton
        }
    }

    // MARK: - body

    var body: some View {
        switch viewModel.exercise.type {
        case "rep": repsView
        case "weight": weightView
        case "duration": durationView
        default: Text("Incorrect type")
        }
    }
}
