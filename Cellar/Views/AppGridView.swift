//
//  AppGridView.swift
//  Cellar
//
//  Created by Dani on 3/10/23.
//

import SwiftUI

struct AppGridView: View {
    var apps: [WineApp]
    
    private let columns = [
        GridItem(
            .adaptive(
                minimum: AppGridItem.size.width,
                maximum: AppGridItem.maximumSize.width),
            spacing: 20
        )
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(apps) { app in
                AppGridItem(app: app)
            }
        }
    }
}

#Preview {
    AppGridView(apps: Context().apps)
        .environmentObject(Context())
        .frame(width: 400, height: 400)
}
