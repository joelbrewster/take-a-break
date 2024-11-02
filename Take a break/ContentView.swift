// ContentView.swift
import SwiftUI

struct ContentView: View {
    @State private var timeRemaining: TimeInterval = 30
    @State private var timerIsRunning = false
    @State private var breakCount = 0
    @State private var showingPreferences = false
    
    private let totalTime: TimeInterval = 30
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
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
        }
        .onReceive(timer) { _ in
            if timerIsRunning {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                    MenuBarController.shared.updateProgress(timeRemaining, total: totalTime) // Ensure you're calling this correctly
                } else {
                    timerComplete()
                }
            }
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func toggleTimer() {
        timerIsRunning.toggle()
    }
    
    private func timerComplete() {
        timerIsRunning = false
        timeRemaining = totalTime
        breakCount += 1
    }
}
