import SwiftUI
import AppKit

class ProgressModel: ObservableObject {
    @Published var progress: Double = 1.0 {
        didSet {
            NotificationCenter.default.post(
                name: Notification.Name("ProgressDidChange"),
                object: self,
                userInfo: ["progress": progress]
            )
        }
    }
}
