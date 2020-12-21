import SwiftUI

struct DetailView: View {
    let exercise: Exercise
    
    @State private var reps: Double = 0
    @State private var isFocused: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                Image(exercise.id)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Divider()
                HStack {
                    Text("Reps")
                    Spacer()
                    Text("\(Int(reps))")
                        .padding()
                        .frame(width: 50)
                        .contentShape(Rectangle())
                        .focusable { isFocused = $0 }
                        .digitalCrownRotation($reps, from: 0, through: 100, by: 1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(isFocused ? Color.green : Color.gray, lineWidth: 2))
                }
                Button("Save"){ }
                Divider()
                Text("🏆").font(.largeTitle)
                Text("15")
                Spacer()
            }
        }.navigationTitle(exercise.name)
    }
}
