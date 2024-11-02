import SwiftUI

@main
struct Take_a_breakApp: App {
    @NSApplicationDelegateAdaptor(TakeABreakDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About Take a break") {
                    NSApplication.shared.orderFrontStandardAboutPanel(nil)
                }
            }
        }
        Settings {
            PreferencesView()
        }
    }
}
