//
//  AppListItem.swift
//  Cellar
//
//  Created by Dani on 7/10/23.
//

import SwiftUI

struct AppListItem: View {
    @EnvironmentObject var context: Context
    var app: WineApp
    
    var icon: Image {
        app.icon ?? Image(systemName: "macwindow")
    }
    
    var isRunning: Bool {
        context.runningApps.contains(app)
    }
    
    var body: some View {
        HStack(spacing: 15) {
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 40)
                .frame(maxWidth: 60)
            Text(app.name)
            Spacer()
            Text(app.winePath.path)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .contextMenu(menuItems: {
            if isRunning {
                Button("Stop") {
                    context.stop(app: app)
                }
            } else {
                Button("Run") {
                    context.run(app: app)
                }
            }
            Button("Edit") {
                context.showEditView(app: app)
            }
            Button("Delete") {
                context.remove(app: app)
            }
        })
    }
}

#Preview {
    AppListItem(app: WineApp.default)
        .environmentObject(Context())
        .padding(10)
}
