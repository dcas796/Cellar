//
//  AppsView.swift
//  Cellar
//
//  Created by Dani on 12/10/23.
//

import SwiftUI

struct AppsView: View {
    @EnvironmentObject var context: Context
    var viewStyle: AppViewStyle
    
    var body: some View {
        switch viewStyle {
        case .grid:
            AppGridView(apps: context.apps)
                .frame(maxHeight: .infinity, alignment: .topLeading)
                .padding()
        case .list:
            AppListView(apps: context.apps)
        }
    }
}

#Preview("List") {
    AppsView(viewStyle: .list)
        .environmentObject(Context())
}

#Preview("Grid") {
    AppsView(viewStyle: .grid)
        .environmentObject(Context())
        .frame(width: 500, height: 500)
}
