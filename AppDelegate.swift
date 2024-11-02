import Cocoa
import UserNotifications

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var hourlyTimer: Timer?
    private var threeHourTimer: Timer?
    private var nextHourlyBreak: Date!
    private var nextLongBreak: Date!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            }
        }
        
        // Setup menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // Start timers
        setupTimers()
        
        // Update display every second
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateMenuBarDisplay()
        }
    }
    
    private func setupTimers() {
        // Initialize next break times
        nextHourlyBreak = Date().addingTimeInterval(3600) // 1 hour
        nextLongBreak = Date().addingTimeInterval(10800)  // 3 hours
        
        // Setup hourly timer
        hourlyTimer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            self?.showNotification(title: "Time for a break!", 
                                 body: "Take a 1-minute break",
                                 identifier: "hourlyBreak")
            self?.nextHourlyBreak = Date().addingTimeInterval(3600)
        }
        
        // Setup three-hour timer
        threeHourTimer = Timer.scheduledTimer(withTimeInterval: 10800, repeats: true) { [weak self] _ in
            self?.showNotification(title: "Time for a longer break!", 
                                 body: "Take a 10-minute break",
                                 identifier: "threeHourBreak")
            self?.nextLongBreak = Date().addingTimeInterval(10800)
        }
    }
    
    private func showNotification(title: String, body: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateMenuBarDisplay() {
        // Find the next closest break
        let nextBreak = min(nextHourlyBreak, nextLongBreak)
        let remaining = Int(nextBreak.timeIntervalSinceNow)
        
        // Format the time
        let minutes = (remaining / 60) % 60
        let seconds = remaining % 60
        
        // Update menu bar
        statusItem.button?.title = String(format: "%02d:%02d", minutes, seconds)
    }
} 