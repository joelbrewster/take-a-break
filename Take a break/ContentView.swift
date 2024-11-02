//
//  ContentView.swift
//  Take a break
//
//  Created by Joel Brewster on 2/11/2024.
//

import SwiftUI

class OverlayWindow: NSWindow {
    init() {
        super.init(
            contentRect: NSScreen.main?.frame ?? .zero,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        self.level = .floating
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = false
        self.isMovableByWindowBackground = false
        self.isReleasedWhenClosed = false
    }
}

class OverlayWindowController: NSWindowController {
    init() {
        let window = OverlayWindow()
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct BreakOverlay: View {
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.15)
                .edgesIgnoringSafeArea(.all)
            
            VisualEffectView(material: .fullScreenUI, blendingMode: .withinWindow)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text(message)
                    .font(.system(size: 36, weight: .light))
                    .foregroundColor(.white)
                
                Button("Continue", action: onDismiss)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            }
        }
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = .active
        return visualEffectView
    }
    
    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}

struct ContentView: View {
    @State private var timeRemaining: TimeInterval = 30
    @State private var isTimerActive = false
    @State private var shortBreakCount = 0
    @State private var maxShortBreaks = 3
    @State private var showingBreakOverlay = false
    @State private var breakMessage = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let overlayWindowController = OverlayWindowController()
    
    var body: some View {
        VStack(spacing: 30) {
            Text(timeString(from: timeRemaining))
                .font(.system(size: 72, weight: .light, design: .rounded))
                .monospacedDigit()
            
            HStack(spacing: 8) {
                ForEach(0..<maxShortBreaks, id: \.self) { index in
                    Circle()
                        .fill(index < shortBreakCount ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            
            Button(action: {
                isTimerActive.toggle()
                if !isTimerActive {
                    timeRemaining = 30
                }
            }) {
                Image(systemName: isTimerActive ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 300, height: 200)
        .onChange(of: showingBreakOverlay) { newValue in
            if newValue {
                showOverlay()
            } else {
                hideOverlay()
            }
        }
        .onReceive(timer) { _ in
            guard isTimerActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isTimerActive = false
                if shortBreakCount < maxShortBreaks {
                    breakMessage = "Take a 30-second break"
                    shortBreakCount += 1
                } else {
                    breakMessage = "Take a 1-minute break"
                    shortBreakCount = 0
                }
                showingBreakOverlay = true
            }
        }
    }
    
    private func showOverlay() {
        let overlayView = BreakOverlay(message: breakMessage) {
            showingBreakOverlay = false
            timeRemaining = 30
            isTimerActive = true
        }
        
        overlayWindowController.window?.contentView = NSHostingView(rootView: overlayView)
        overlayWindowController.window?.makeKeyAndOrderFront(nil)
        
        if let screen = NSScreen.main {
            overlayWindowController.window?.setFrame(screen.frame, display: true)
        }
    }
    
    private func hideOverlay() {
        overlayWindowController.window?.orderOut(nil)
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
