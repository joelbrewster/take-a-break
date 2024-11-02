//
//  ContentView.swift
//  Take a break
//
//  Created by Joel Brewster on 2/11/2024.
//

import SwiftUI

// Define TimerView first
struct TimerView: View {
    let title: String
    let timeRemaining: TimeInterval
    let totalTime: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            
            HStack {
                Text(timeString(from: timeRemaining))
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(color)
                
                Spacer()
                
                ProgressView(value: timeRemaining, total: totalTime)
                    .progressViewStyle(.linear)
                    .frame(width: 100)
                    .tint(color)
            }
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// Then define ContentView
struct ContentView: View {
    @State private var nextHourlyBreak: TimeInterval = 3600
    @State private var nextLongBreak: TimeInterval = 10800
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Break Timer")
                .font(.title)
                .padding()
            
            VStack(alignment: .leading, spacing: 15) {
                TimerView(
                    title: "Next Short Break",
                    timeRemaining: nextHourlyBreak,
                    totalTime: 3600,
                    color: .blue
                )
                
                TimerView(
                    title: "Next Long Break",
                    timeRemaining: nextLongBreak,
                    totalTime: 10800,
                    color: .green
                )
            }
            .padding()
        }
        .frame(width: 300, height: 200)
    }
}

#Preview {
    ContentView()
}
