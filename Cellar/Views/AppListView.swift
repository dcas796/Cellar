//
//  AppListView.swift
//  Cellar
//
//  Created by Dani on 3/10/23.
//

import SwiftUI

struct AppListView: View {
    var apps: [WineApp]
    
    @State var selectedApps: Set<WineApp> = []
    
    var body: some View {
        List(apps, id: \.self, selection: $selectedApps) { app in
            AppListItem(app: app)
                .padding(5)
        }
        
    }
}

#Preview {
    AppListView(apps: Context().apps)
}
