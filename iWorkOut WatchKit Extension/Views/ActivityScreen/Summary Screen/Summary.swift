import SwiftUI

struct Summary: View {

    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var viewModel: ActivityViewModel
    @State private var alertType: Int = 0
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
            Button("SAVE") {
                viewModel.dataManager.end()
                saveWorkout(
                    CDRecordTotal: Record.getRecord(
                        CDRecord: viewModel.fetchedRecord,
                        exerciseId: viewModel.exercise.id
                    )
                )
            }
            .foregroundColor(.green)
        }
        .alert(isPresented: $isPresented) {
            createCustomAlert(
                alertType: alertType,
                CDRecordSum: viewModel.fetchedRecord?.sum ?? 0,
                currentRecordSum: viewModel.record[1]! + viewModel.record[2]! + viewModel.record[3]!,
                dismissfunction: { presentation.wrappedValue.dismiss() }
            )
        }
    }

    func createNewRecord() {
        alertType = 1
        viewModel.createNewRecord(record: viewModel.record)
        isPresented = true
    }

    func updateExistingRecord() {
        alertType = 2
        viewModel.updateExistingRecord(record: viewModel.record)
        isPresented = true
    }

    func failedBeatRecord() {
        alertType = 3
        isPresented = true
    }

    func saveWorkout(CDRecordTotal: Int64) {
        if CDRecordTotal == 0 {
            createNewRecord()
        } else {
            if viewModel.record[1]! + viewModel.record[2]! + viewModel.record[3]! > CDRecordTotal {
                updateExistingRecord()
            } else {
                failedBeatRecord()
            }
        }
    }
}
