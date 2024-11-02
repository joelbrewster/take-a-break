// import SwiftUI

// class TimerManager: ObservableObject {
//     @Published var timeRemaining: TimeInterval = 30
//     @Published var isTimerRunning = false
//     @Published var breakCount = 0
//     private let totalTime: TimeInterval = 30
    
//     func toggleTimer() {
//         if isTimerRunning {
//             isTimerRunning = false
//         } else {
//             if timeRemaining == totalTime {
//                 startTimer()
//             } else {
//                 isTimerRunning = true
//             }
//         }
//     }
    
//     func startTimer() {
//         timeRemaining = totalTime
//         isTimerRunning = true
//     }
    
//     func timerComplete() {
//         isTimerRunning = false
//         timeRemaining = totalTime
//         breakCount += 1
//     }
    
//     func timeString(from timeInterval: TimeInterval) -> String {
//         let minutes = Int(ceil(timeInterval)) / 60
//         let seconds = Int(ceil(timeInterval)) % 60
//         return String(format: "%02d:%02d", minutes, seconds)
//     }
// }

// struct ContentView: View {
//     @StateObject private var timerManager = TimerManager()
//     private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
//     var body: some View {
//         VStack(spacing: 30) {
//             Text(timerManager.timeString(from: timerManager.timeRemaining))
//                 .font(.system(size: 72, weight: .light, design: .rounded))
//                 .monospacedDigit()
            
//             HStack(spacing: 16) {
//                 ForEach(0..<timerManager.breakCount, id: \.self) { _ in
//                     Circle()
//                         .fill(Color.blue)
//                         .frame(width: 8, height: 8)
//                 }
//             }
            
//             Button(action: timerManager.toggleTimer) {
//                 Image(systemName: timerManager.isTimerRunning ? "pause.circle.fill" : "play.circle.fill")
//                     .resizable()
//                     .frame(width: 44, height: 44)
//                     .foregroundColor(.blue)
//             }
//             .buttonStyle(PlainButtonStyle())
//         }
//         .frame(width: 300, height: 200)
//         .onReceive(timer) { _ in
//             if timerManager.isTimerRunning {
//                 if timerManager.timeRemaining > 1 {
//                     timerManager.timeRemaining -= 1
//                     // Update menu bar controller
//                     if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
//                         appDelegate.menuBarController.updateProgress(timerManager.timeRemaining, total: 30)
//                     }
//                 } else {
//                     timerManager.timerComplete()
//                 }
//             }
//         }
//     }
// } 