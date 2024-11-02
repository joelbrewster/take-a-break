import SwiftUI

struct PreferencesView: View {
    @AppStorage("menuBarIconSize") private var menuBarIconSize: Double = 14
    
    var body: some View {
        Form {
            Section("Menu Bar") {
                VStack(alignment: .leading) {
                    Text("Icon Size")
                    Slider(value: $menuBarIconSize, in: 10...18, step: 1) {
                        Text("Size")
                    }
                }
            }
        }
        .padding()
        .frame(width: 350, height: 150)
    }
} 
