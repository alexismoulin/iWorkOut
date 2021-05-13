import SwiftUI

struct DetailView: View {

    // MARK: - Properties

    @StateObject private var viewModel: ViewModel

    @State private var reps: Double = 0
    @State private var imageAnimationFrame: Int = 0
    @State private var displayInstructions: Bool = false

    // MARK: - Custom init

    init(dataController: DataController, dataManager: DataManager, exercise: Exercise) {
        let viewModel = ViewModel(dataController: dataController, dataManager: dataManager, exercise: exercise)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Components

    func createRecordRow() -> some View {
            VStack {
                Image(systemName: "crown")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.yellow)
                    .frame(height: 32)
                Text("\(viewModel.fetchedRecord?.sum ?? 0)").fontWeight(.bold)
            }
    }

    // MARK: - body

    var body: some View {
        ScrollView {
            VStack {
                Image(imageAnimationFrame % 2 == 0 ? "\(viewModel.exercise.id)-a" : "\(viewModel.exercise.id)-b")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                NavigationLink(destination: ActivityView(
                    dataController: viewModel.dataController,
                    dataManager: viewModel.dataManager,
                    exercise: viewModel.exercise,
                    fetchedRecord: viewModel.fetchedRecord
                )) {
                    Text("START").foregroundColor(.lime)
                }
                .padding(.vertical)
                Divider()
                createRecordRow()
                Spacer()
            }
        }
        .navigationTitle(viewModel.exercise.name)
        .onAppear(perform: animateExerciseImage)
    }

    // MARK: - functions

    func animateExerciseImage() {
        for halfSecond in 0..<20 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 * Double(halfSecond)) {
                imageAnimationFrame += 1
            }
        }
    }

}
