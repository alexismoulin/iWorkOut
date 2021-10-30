import SwiftUI

struct DetailView: View {

    // MARK: - Properties

    @StateObject private var viewModel: DetailViewModel
    @State private var index: Int = 0

    var images: [UIImage?] {
        [UIImage(named: "\(viewModel.exercise.id)-a"), UIImage(named: "\(viewModel.exercise.id)-b")]
    }

    private var timer = AnimatedImageTimer()

    // MARK: - Custom init

    init(dataController: DataController, dataManager: DataManager, exercise: Exercise) {
        let viewModel = DetailViewModel(dataController: dataController, dataManager: dataManager, exercise: exercise)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Components

    var recordItem: some View {
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
                Image(uiImage: images[index % 2] ?? UIImage(named: "null")!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onReceive(timer.publisher) { _ in
                        index += 1
                    }
                    .onAppear { self.timer.start() }
                    .onDisappear { self.timer.cancel() }

                NavigationLink(
                    destination: ActivityView(
                        dataController: viewModel.dataController,
                        dataManager: viewModel.dataManager,
                        exercise: viewModel.exercise,
                        fetchedRecord: viewModel.fetchedRecord
                    )
                ) {
                    Text("START").foregroundColor(.lime)
                }
                .padding(.vertical)
                Divider()
                recordItem
                Spacer()
            }
        }
        .navigationTitle(viewModel.exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }

}
