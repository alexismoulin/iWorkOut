import SwiftUI

struct DetailView: View {

    // MARK: - Properties

    @StateObject private var viewModel: ViewModel

    @State private var reps: Double = 0
    @State private var imageAnimationFrame: Int = 0
    @State private var displayInstructions: Bool = false
    @State private var index: Int = 0

    var images: [UIImage?] {
        [UIImage(named: "\(viewModel.exercise.id)-a"), UIImage(named: "\(viewModel.exercise.id)-b")]
    }

    private var timer = AnimatedImageTimer()

    // MARK: - Custom init

    init(dataController: DataController, dataManager: DataManager, exercise: Exercise) {
        let viewModel = ViewModel(dataController: dataController, dataManager: dataManager, exercise: exercise)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Components

    func createRecordRow() -> some View {
        NavigationLink(destination: DetailRecordView(fetchedRecord: viewModel.fetchedRecord)) {
            VStack {
                Image(systemName: "crown")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.yellow)
                    .frame(height: 32)
                Text("\(viewModel.fetchedRecord?.sum ?? 0)").fontWeight(.bold)
            }
        }.buttonStyle(PlainButtonStyle())
    }

    // MARK: - body

    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: images[index % 2] ?? UIImage(named: "null")!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onReceive(timer.publisher) { _ in
                        index += 1
                    }
                    .onAppear { self.timer.start() }
                    .onDisappear { self.timer.cancel() }

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
    }

}
