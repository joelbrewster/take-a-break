import SwiftUI

struct PreferencesView: View {
    @AppStorage("timerDuration") private var timerDuration: Double = 25  // Default 25 minutes
    
    var body: some View {
        Form {
            Section("Timer") {
                HStack {
                    Text("Duration (minutes)")
                    TextField("", value: $timerDuration, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                }
            }
        }
        .padding()
        .frame(width: 350, height: 150)
    }
} 
