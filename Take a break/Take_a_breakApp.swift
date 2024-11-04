import SwiftUI

@main
struct Take_a_breakApp: App {
    @NSApplicationDelegateAdaptor(TakeABreakDelegate.self) var appDelegate
    
    init() {
        NSApplication.shared.orderedWindows.first?.level = .floating
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 300, height: 420)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About Take a break") {
                    let credits = NSAttributedString(string: "Joel Brewster")
                    NSApplication.shared.orderFrontStandardAboutPanel(
                        options: [NSApplication.AboutPanelOptionKey.credits: credits]
                    )
                }
            }
            
            CommandGroup(after: .appInfo) {
                Button("Reset Timer") {
                    NotificationCenter.default.post(name: Notification.Name("ResetTimer"), object: nil)
                }
                .keyboardShortcut("r", modifiers: .command)
            }
        }
        Settings {
            PreferencesView()
        }
    }
}