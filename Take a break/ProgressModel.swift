import Combine

class ProgressModel: ObservableObject {
    @Published var progress: Double = 1.0 // Default value of progress
}
