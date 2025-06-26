//
//  AppListView.swift
//  Cellar
//
//  Created by Dani on 3/10/23.
//

import SwiftUI

struct AppListView: View {
    var apps: [WineApp]
    
    @Binding var selectedApp: WineApp?
    
    var body: some View {
        List(apps, id: \.self, selection: $selectedApp) { app in
            AppListItem(app: app)
                .padding(5)
        }
        
    }
}

#Preview {
    AppListView(apps: Context().apps, selectedApp: .constant(nil))
}
