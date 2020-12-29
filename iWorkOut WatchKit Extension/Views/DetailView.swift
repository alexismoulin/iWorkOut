import SwiftUI

struct DetailView: View {
    let exercise: Exercise
    
    @State private var reps: Double = 0
    @State private var isFocused: Bool = false
    let defaults = UserDefaults.standard
    
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
                Button("Save"){
                    defaults.set(Int(reps), forKey: exercise.id)
                    print(defaults.integer(forKey: exercise.id))
                }
                Divider()
                Text("🏆").font(.largeTitle)
                Text("\(Int(reps))")
                Spacer()
            }
        }
        .navigationTitle(exercise.name)
        .onAppear { reps = Double(defaults.integer(forKey: exercise.id)) }
    }
}
