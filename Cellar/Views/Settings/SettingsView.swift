//
//  SettingsView.swift
//  Cellar
//
//  Created by Dani on 14/10/23.
//

import SwiftUI

enum SettingsTab {
    case wine
}

struct SettingsView: View {
    var body: some View {
        TabView {
            WineSettingsView()
                .tabItem {
                    Label("Wine Settings", systemImage: "wineglass")
                }
                .tag(SettingsTab.wine)
        }
        .frame(minWidth: 400,
               maxWidth: .infinity,
               minHeight: 200,
               maxHeight: .infinity)
    }
}

#Preview {
    SettingsView()
}
