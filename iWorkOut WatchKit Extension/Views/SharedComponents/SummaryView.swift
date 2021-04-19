import SwiftUI

struct SummaryView: View {

    // MARK: - Properties

    let set1Value: Int
    let set2Value: Int
    let set3Value: Int
    var totalSum: Int {
        set1Value + set2Value + set3Value
    }
    let calories: Int
    let heartRate: Int

    // MARK: - body

    var body: some View {
        Group {
            Section(header: Text("Reps per set")) {
                HStack {
                    Text("Set 1:")
                    Spacer()
                    Text("\(set1Value)")
                }
                HStack {
                    Text("Set 2:")
                    Spacer()
                    Text("\(set2Value)")
                }
                HStack {
                    Text("Set 3:")
                    Spacer()
                    Text("\(set3Value)")
                }
            }
            Section(header: Text("Total")) {
                HStack {
                    Text("Total sum:")
                    Spacer()
                    Text("\(totalSum)")
                }
            }
            Section(header: Text("Colories")) {
                HStack {
                    Text("Total burned:")
                    Spacer()
                    Text("\(calories)")
                }
            }
            Section(header: Text("Heart Rate")) {
                HStack {
                    Text("Average BPM:")
                    Spacer()
                    Text("\(heartRate)")
                }
            }
        }
    }
}
