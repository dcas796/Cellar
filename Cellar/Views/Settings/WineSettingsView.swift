//
//  WineSettingsView.swift
//  Cellar
//
//  Created by Dani on 14/10/23.
//

import SwiftUI

struct WineSettingsView: View {
    @State var prefix: String = Settings.shared.winePrefix.path(percentEncoded: false)
    @State var executable: String = Settings.shared.wineExecutable.path(percentEncoded: false)
    
    var body: some View {
        VStack {
            Form {
                TextField("Wine Prefix", text: $prefix)
                TextField("Wine Executable",
                          text: $executable,
                          prompt: Text("Automatic"))
            }
            .onSubmit(saveSettings)
            .formStyle(.grouped)
            HStack {
                Spacer()
                Button("Save") {
                    saveSettings()
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(20)
        }
    }
    
    func saveSettings() {
        Settings.shared.winePrefix = URL(filePath: prefix)
        Settings.shared.wineExecutable = URL(filePath: executable)
    }
}

#Preview {
    WineSettingsView()
}
