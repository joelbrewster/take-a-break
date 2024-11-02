import Cocoa
import SwiftUI

class TakeABreakDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var timerView: NSHostingView<MenuBarTimerView>?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
    }
    
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: 22)
        
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
