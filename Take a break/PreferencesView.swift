import SwiftUI

struct PreferencesView: View {
    @AppStorage("timerDuration") private var timerDuration: Double = 25
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Duration (minutes)")
                    TextField("", value: $timerDuration, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .frame(width: 350, height: 80)
    }
} 
