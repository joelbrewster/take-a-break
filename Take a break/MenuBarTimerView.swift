// MenuBarTimerView.swift
import SwiftUI

struct MenuBarTimerView: View {
    @ObservedObject var model: ProgressModel
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), lineWidth: 2)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: model.progress)
                .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 14, height: 14)
        .contentShape(Rectangle())
        .onTapGesture {
            if let window = NSApplication.shared.windows.first {
                window.makeKeyAndOrderFront(nil)
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
        }
    }
}
