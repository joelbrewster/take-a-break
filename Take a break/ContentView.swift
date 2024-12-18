// ContentView.swift
import SwiftUI
import UserNotifications

struct ContentView: View {
    @AppStorage("timerDuration") private var timerDuration: Double = 25
    @State private var timeRemaining: TimeInterval = 0
    @State private var timerIsRunning = false
    @State private var breakCount = 0
    @State private var showingPreferences = false
    
    private var totalTime: TimeInterval { timerDuration * 60 }
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                Text(timeString(from: timeRemaining))
                    .font(.system(size: 72, weight: .light, design: .rounded))
                    .monospacedDigit()
                    .padding(.top, 72)
                
                HStack(spacing: 16) {
                    ForEach(0..<(breakCount / 5), id: \.self) { _ in
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .frame(width: 12, height: 12)
                    }
                    
                    ForEach(0..<(breakCount % 5), id: \.self) { _ in
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Button(action: toggleTimer) {
                    Image(systemName: timerIsRunning ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 66, height: 66)
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 72)
                
                Spacer()
            }
            .frame(width: 300, height: 260)
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
        .onAppear {
            timeRemaining = totalTime
            requestNotificationPermissions()
            NotificationCenter.default.addObserver(
                forName: Notification.Name("ResetTimer"),
                object: nil,
                queue: .main
            ) { _ in
                timeRemaining = totalTime
                if timerIsRunning {
                    timerIsRunning = false
                }
            }
        }
        .onChange(of: timerDuration) { newValue in
            timeRemaining = newValue * 60
            if timerIsRunning {
                timerIsRunning = false
            }
        }
        .keyboardShortcut(.space, modifiers: [])
        .keyboardShortcut("r", modifiers: .command)
        .onChange(of: timeRemaining) { _ in
            if timeRemaining == totalTime {
                timerIsRunning = false
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
        
        let content = UNMutableNotificationContent()
        content.title = "Break Time!"
        content.body = "It's time to take a break."
        content.sound = .default  // Uses the default system notification sound
        
        // For a custom sound, use:
        // content.sound = UNNotificationSound(named: UNNotificationSoundName("your-sound-file.wav"))
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
        
        // Also play a sound immediately
        NSSound.beep()  // Simple system beep
        
        // Or for a custom sound:
        // if let sound = NSSound(named: "your-sound-file") {
        //     sound.play()
        // }
    }
}
