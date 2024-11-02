import SwiftUI

class MenuBarController {
    static let shared = MenuBarController()
    private var statusItem: NSStatusItem
    private var timerView: NSHostingView<MenuBarTimerView>?
    
    private init() {
        statusItem = NSStatusBar.system.statusItem(withLength: 22)
        setupTimerView()
    }
    
    private func setupTimerView() {
        timerView = NSHostingView(
            rootView: MenuBarTimerView(progress: 1.0)
        )
        timerView?.frame = NSRect(x: 0, y: 0, width: 22, height: 22)
        statusItem.button?.addSubview(timerView!)
    }
    
    func updateProgress(_ timeRemaining: TimeInterval, total: TimeInterval) {
        let progress = timeRemaining / total
        timerView?.rootView = MenuBarTimerView(progress: progress)
    }
}