import SwiftUI
import Cocoa

class MenuBarController {
    private var statusItem: NSStatusItem
    private var timerView: NSHostingView<MenuBarTimerView>?
    
    init() {
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

struct MenuBarTimerView: View {
    @Environment(\.colorScheme) var colorScheme
    let progress: Double
    
    var foregroundColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(foregroundColor.opacity(0.3), lineWidth: 0.5)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(foregroundColor, lineWidth: 0.5)
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 14, height: 14)
        .padding(.horizontal, 4)
    }
} 