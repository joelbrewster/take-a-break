import Cocoa
import SwiftUI

class TakeABreakDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var timerView: NSHostingView<MenuBarTimerView>?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
    }
    
    private func setupMenuBar() {
        // Initialize the status item
        statusItem = NSStatusBar.system.statusItem(withLength: 22)

        // Use the shared instance of ProgressModel from MenuBarController
        timerView = NSHostingView(rootView: MenuBarTimerView(model: MenuBarController.shared.model))
        timerView?.frame = NSRect(x: 0, y: 0, width: 22, height: 22)
        statusItem.button?.addSubview(timerView!)
    }
    
    func updateProgress(_ timeRemaining: TimeInterval, total: TimeInterval) {
        // Update the progress in the shared model
        MenuBarController.shared.updateProgress(timeRemaining, total: total)
        // Since MenuBarTimerView observes the model, it will automatically update
    }
}
