//
//  ContentView.swift
//  Take a break
//
//  Created by Joel Brewster on 2/11/2024.
//

import SwiftUI

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
                .stroke(foregroundColor.opacity(0.3), lineWidth: 2)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(foregroundColor, lineWidth: 2)
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 14, height: 14)
        .padding(10)
    }
}

struct ContentView: View {
    // Basic timer states
    @State private var timeRemaining: TimeInterval = 30
    @State private var timerIsRunning = false
    @State private var breakCount = 0
    
    private let totalTime: TimeInterval = 30
    private let menuBarController = MenuBarController()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 30) {
            Text(timeString(from: timeRemaining))
                .font(.system(size: 72, weight: .light, design: .rounded))
                .monospacedDigit()
            
            HStack(spacing: 16) {
                ForEach(0..<breakCount, id: \.self) { _ in
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                }
            }
            
            Button(action: toggleTimer) {
                Image(systemName: timerIsRunning ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 300, height: 200)
        .onReceive(timer) { _ in
            if timerIsRunning {
                if timeRemaining > 1 {
                    timeRemaining -= 1
                    menuBarController.updateProgress(timeRemaining, total: totalTime)
                } else {
                    timerComplete()
                }
            }
        }
    }
    
    private func toggleTimer() {
        if timerIsRunning {
            timerIsRunning = false
        } else {
            if timeRemaining == totalTime {
                startTimer()
            } else {
                timerIsRunning = true
                menuBarController.updateProgress(timeRemaining, total: totalTime)
            }
        }
    }
    
    private func startTimer() {
        timeRemaining = totalTime
        timerIsRunning = true
        menuBarController.updateProgress(timeRemaining, total: totalTime)
    }
    
    private func timerComplete() {
        timerIsRunning = false
        timeRemaining = totalTime
        breakCount += 1
        menuBarController.updateProgress(totalTime, total: totalTime)
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(ceil(timeInterval)) / 60
        let seconds = Int(ceil(timeInterval)) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
