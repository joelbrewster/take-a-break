import SwiftUI

@main
struct Take_a_breakApp: App {
    @NSApplicationDelegateAdaptor(TakeABreakDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 300, height: 400)
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