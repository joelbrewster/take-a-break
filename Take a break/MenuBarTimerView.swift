// MenuBarTimerView.swift
import SwiftUI

struct MenuBarTimerView: View {
    @ObservedObject var model: ProgressModel

    var body: some View {
            ZStack {
                // Background circle (transparent)
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: model.progress)
                    .stroke(Color.white, lineWidth: 2)
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: 14, height: 14) // Slightly smaller than the 22x22 container
            .contentShape(Rectangle())  // Make entire area clickable
            .onTapGesture {
                if let window = NSApplication.shared.windows.first {
                    window.makeKeyAndOrderFront(nil)
                    NSApplication.shared.activate(ignoringOtherApps: true)
                }
            }
        }
}
