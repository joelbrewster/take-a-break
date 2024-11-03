// MenuBarController.swift
import SwiftUI
import AppKit

class MenuBarController {
    static let shared = MenuBarController()
    private var statusItem: NSStatusItem?
    private var timerView: NSHostingView<MenuBarTimerView>?
    private var timer: Timer?
    var model = ProgressModel() // Make this var to allow updates

    private init() {}

    func startTimer(total: TimeInterval) {
        if statusItem == nil {
            statusItem = NSStatusBar.system.statusItem(withLength: 22)
            setupTimerView()
        }

        model.progress = 1.0 // Initialize progress at the start

        // Schedule timer to update progress
        let interval: TimeInterval = 1.0
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            let elapsed = min(total, -timer.fireDate.timeIntervalSinceNow)
            self.model.progress = max(0, 1.0 - elapsed / total)

            if self.model.progress <= 0 {
                self.stopTimer()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        if let button = statusItem?.button, timerView != nil {
            timerView?.removeFromSuperview()
            timerView = nil
        }
        NSStatusBar.system.removeStatusItem(statusItem!)
        statusItem = nil
    }

    private func setupTimerView() {
        // Create status item with fixed width
        statusItem = NSStatusBar.system.statusItem(withLength: 28)
        
        timerView = NSHostingView(rootView: MenuBarTimerView(model: model))
        timerView?.frame = NSRect(x: 0, y: 0, width: 22, height: 22)
        
        if let button = statusItem?.button {
            // Add the timer view as a subview
            button.addSubview(timerView!)
            
            // Set up click monitoring for the entire button area
            let monitor = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown]) { [weak self] event in
                guard let self = self,
                      let buttonWindow = self.statusItem?.button?.window else { return event }
                
                if buttonWindow.frame.contains(event.locationInWindow) {
                    if let window = NSApplication.shared.windows.first {
                        window.makeKeyAndOrderFront(nil)
                        NSApplication.shared.activate(ignoringOtherApps: true)
                    }
                }
                return event
            }
        }
    }

    func updateProgress(_ timeRemaining: TimeInterval, total: TimeInterval) {
        // Calculate progress and update model
        let progress = max(0, 1.0 - (timeRemaining / total))
        model.progress = progress
    }
}
