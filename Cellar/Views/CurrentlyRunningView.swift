//
//  CurrentlyRunningView.swift
//  Cellar
//
//  Created by Dani on 13/10/23.
//

import SwiftUI

struct CurrentlyRunningView: View {
    @EnvironmentObject var context: Context
    
    var viewStyle: AppViewStyle
    @Binding var selectedApp: WineApp?
    
    var body: some View {
        if context.runningApps.isEmpty {
            Text("No currently running apps.")
                .font(.title)
                .foregroundStyle(Color.secondary)
        } else {
            switch viewStyle {
            case .grid:
                AppGridView(apps: context.runningApps, selectedApp: $selectedApp)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .padding()
            case .list:
                AppListView(apps: context.runningApps, selectedApp: $selectedApp)
            }
        }
    }
}

#Preview("List") {
    CurrentlyRunningView(viewStyle: .list, selectedApp: .constant(nil))
        .environmentObject(Context())
}

#Preview("Grid") {
    CurrentlyRunningView(viewStyle: .grid, selectedApp: .constant(nil))
        .environmentObject(Context())
        .frame(width: 500, height: 500)
}
