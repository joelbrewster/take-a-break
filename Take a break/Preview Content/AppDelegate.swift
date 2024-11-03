import Cocoa
import SwiftUI

class TakeABreakDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var timerView: NSHostingView<MenuBarTimerView>?
    private var dockIcon: DockIconView?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        setupDockIcon()
        
        // Start observing the progress model
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(progressDidChange),
            name: NSNotification.Name("ProgressDidChange"),
            object: nil
        )
        
        // Force dock icon update immediately
        NSApplication.shared.dockTile.contentView = dockIcon
        NSApplication.shared.dockTile.display()
    }
    
    private func setupMenuBar() {
        // Initialize the status item
        statusItem = NSStatusBar.system.statusItem(withLength: 22)

        // Use the shared instance of ProgressModel from MenuBarController
        timerView = NSHostingView(rootView: MenuBarTimerView(model: MenuBarController.shared.model))
        timerView?.frame = NSRect(x: 0, y: 0, width: 22, height: 22)
        statusItem.button?.addSubview(timerView!)
    }
    
    private func setupDockIcon() {
        dockIcon = DockIconView(frame: NSRect(x: 0, y: 0, width: 128, height: 128))
        NSApplication.shared.dockTile.contentView = dockIcon
        NSApplication.shared.dockTile.display()
    }
    
    @objc private func progressDidChange() {
        // Update dock icon whenever progress changes
        dockIcon?.progress = MenuBarController.shared.model.progress
        NSApplication.shared.dockTile.display()
    }
    
    func updateProgress(_ timeRemaining: TimeInterval, total: TimeInterval) {
        // Update the progress in the shared model
        MenuBarController.shared.updateProgress(timeRemaining, total: total)
    }
}
