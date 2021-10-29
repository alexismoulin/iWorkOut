import SwiftUI

struct Summary: View {

    enum AlertType: CaseIterable {
        case new, beat, fail, error
    }

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: ActivityViewModel
    @State private var isPresented: Bool = false

    var body: some View {
        Form {
            SummaryView(
                set1Value: viewModel.record[1] ?? 0,
                set2Value: viewModel.record[2] ?? 0,
                set3Value: viewModel.record[3] ?? 0,
                calories: Int(viewModel.dataManager.totalEnergyBurned),
                heartRate: viewModel.dataManager.calculateBPM()
            )
            Button {
                viewModel.dataManager.end()
                isPresented = true
            } label: {
                HStack {
                    Text("Proceed").bold()
                    Image(systemName: "checkmark.bubble")
                }.foregroundColor(.lime)
            }
        }.alert(
            createAlertTitle(alertType: calculateAlertType()),
            isPresented: $isPresented,
            actions: {
                Button("SAVE") {
                    saveWorkout(alertType: calculateAlertType())
                    dismiss.callAsFunction()
                }
            },
            message: { createAlertBody(alertType: calculateAlertType()) }
        )
    }

    // MARK: - Helper functions

    func calculateAlertType() -> AlertType {
        let CKsum: Int = viewModel.fetchedRecord?.sum ?? 0
        let sum = viewModel.record.values.reduce(0, +)
        print("CK record: \(CKsum)")
        print("record normal: \(sum)")
        if CKsum == 0 {
            print("NEW")
            return .new
        } else if sum > CKsum {
            print("BEAT")
            return .beat
        } else if sum <= CKsum {
            print("FAIL")
            return .fail
        } else {
            print("ERROR")
            return .error
        }
    }

    func saveWorkout(alertType: AlertType) {
        switch alertType {
        case .new:
            viewModel.createNewRecord(record: viewModel.record)
        case .beat:
            viewModel.updateExistingRecord(record: viewModel.record)
        case .fail:
            break
        case .error:
            break
        }
    }

    func createAlertTitle(alertType: AlertType) -> String {
        switch alertType {
        case .new:
            return "Well Done"
        case .beat:
            return "Congratulations"
        case .fail:
            return "Try Again"
        case .error:
            return "Error"
        }
    }

    func createAlertBody(alertType: AlertType) -> Text {
        let CKsum: Int = viewModel.fetchedRecord?.sum ?? 0
        let sum = viewModel.record.values.reduce(0, +)
        switch alertType {
        case .new:
            return Text("You have completed a New Exercise.\nYour record is **\(sum)**")
        case .beat:
            return Text("You have beaten your previous record of **\(CKsum)**\nYour new record is **\(sum)**")
        case .fail:
            return Text("You didn't beat your previous record of **\(CKsum)**\nYour current score is **\(sum)**")
        case .error:
            return Text("Something went wrong")
        }
    }

}
