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
    
    var body: some View {
        if context.runningApps.isEmpty {
            Text("No currently running apps.")
        } else {
            switch viewStyle {
            case .grid:
                AppGridView(apps: context.runningApps)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .padding()
            case .list:
                AppListView(apps: context.runningApps)
            }
        }
    }
}

#Preview("List") {
    CurrentlyRunningView(viewStyle: .list)
        .environmentObject(Context())
}

#Preview("Grid") {
    CurrentlyRunningView(viewStyle: .grid)
        .environmentObject(Context())
        .frame(width: 500, height: 500)
}
