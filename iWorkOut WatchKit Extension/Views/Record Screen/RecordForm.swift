import SwiftUI

struct RecordForm: View {
    let record: Record?

    var body: some View {
        Form {
            SummaryView(
                set1Value: Int(record?.set1 ?? 0),
                set2Value: Int(record?.set2 ?? 0),
                set3Value: Int(record?.set3 ?? 0),
                calories: Int(record?.calories ?? 0),
                heartRate: Int(record?.heartRate ?? 0)
            )
        }.navigationTitle("Details")
    }
}
