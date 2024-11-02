import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    static let shared = AppDelegate()
    
    var window: NSWindow!
    var menuBarController: MenuBarController!
    var contentView: ContentView!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create shared instances
        contentView = ContentView()
        menuBarController = MenuBarController(contentView: contentView)
        
        // Setup main window
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Take a Break"
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        window.makeKeyAndOrderFront(nil)
        return true
    }
} 