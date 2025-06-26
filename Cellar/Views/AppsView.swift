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
    
    @Binding var selectedApp: WineApp?
    
    var body: some View {
        switch viewStyle {
        case .grid:
            AppGridView(apps: context.apps, selectedApp: $selectedApp)
                .frame(maxHeight: .infinity, alignment: .topLeading)
        case .list:
            AppListView(apps: context.apps, selectedApp: $selectedApp)
        }
    }
}

#Preview("List") {
    AppsView(viewStyle: .list, selectedApp: .constant(nil))
        .environmentObject(Context())
}

#Preview("Grid") {
    AppsView(viewStyle: .grid, selectedApp: .constant(nil))
        .environmentObject(Context())
        .frame(width: 500, height: 500)
}
