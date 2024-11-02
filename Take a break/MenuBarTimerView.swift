import SwiftUI

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
        .padding(.horizontal, 8)
    }
}
