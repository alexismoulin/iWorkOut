import SwiftUI

struct DetailRecordView: View {
    let fetchedRecord: Record?
    var body: some View {
        Form {
            SummaryView(
                set1Value: Int(fetchedRecord?.set1 ?? 0),
                set2Value: Int(fetchedRecord?.set2 ?? 0),
                set3Value: Int(fetchedRecord?.set3 ?? 0),
                calories: Int(fetchedRecord?.calories ?? 0),
                heartRate: Int(fetchedRecord?.heartRate ?? 0)
            )
        }.navigationTitle("Details")
    }
}
