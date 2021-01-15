import SwiftUI

struct RecordForm: View {
    let record: Record?
    var totalsum: Int64 {
        (record?.set1 ?? 0) + (record?.set2 ?? 0) + (record?.set3 ?? 0)
    }
    var body: some View {
        Form {
            Section(header: Text("Reps per set")) {
                HStack {
                    Text("Set 1:")
                    Spacer()
                    Text("\(record?.set1 ?? 0)")
                }
                HStack {
                    Text("Set 2:")
                    Spacer()
                    Text("\(record?.set2 ?? 0)")
                }
                HStack {
                    Text("Set 3:")
                    Spacer()
                    Text("\(record?.set3 ?? 0)")
                }
            }
            Section(header: Text("Total")) {
                HStack {
                    Text("Total sum:")
                    Spacer()
                    Text("\(totalsum)")
                }
            }
            Section(header: Text("Colories")) {
                HStack {
                    Text("Total burned:")
                    Spacer()
                    Text("\(record?.calories ?? 0)")
                }
            }
        }.navigationTitle("Details")
    }
}
