//
//  ContentView.swift
//  Cellar
//
//  Created by Dani on 6/10/23.
//

import SwiftUI

enum AppViewStyle: String, CaseIterable {
    case grid
    case list
}

enum NavigationViews {
    case allApps
    case currentlyRunning
}

struct ContentView: View {
    @EnvironmentObject var context: Context
    
    @State var selectedNavigationView: NavigationViews = .allApps
    @State var viewStyle: AppViewStyle = .grid
    @State var isNewAppSheetPresent: Bool = false
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedNavigationView) {
                Label("All Apps", systemImage: "square.grid.2x2")
                    .tag(NavigationViews.allApps)
                Label("Currently Running", systemImage: "arrowtriangle.right.circle")
                    .tag(NavigationViews.currentlyRunning)
            }
            .listStyle(.sidebar)
            .frame(minWidth: 170)
        } detail: {
            switch selectedNavigationView {
            case .allApps:
                AppsView(viewStyle: viewStyle)
            case .currentlyRunning:
                CurrentlyRunningView(viewStyle: viewStyle)
            }
        }
        .frame(minWidth: 700,
               maxWidth: .infinity,
               minHeight: 300,
               maxHeight: .infinity,
               alignment: .topLeading)
        .toolbar {
            Button("Reset apps") {
                CellarApp.showModal(
                    title: "Are you sure you want to reset all apps?",
                    description: "This action cannot be undone.",
                    showsCancelButton: true,
                    blocking: false) {
                        context.throwing {
                            try DataController.shared?.destroy()
                        }
                        context.objectWillChange.send()
                    }
            }
            Button {
                self.isNewAppSheetPresent = true
            } label: {
                Image(systemName: "plus")
            }
            Picker("View Style", selection: $viewStyle) {
                ForEach(AppViewStyle.allCases, id: \.self) { style in
                    switch style {
                    case .grid:
                        Image(systemName: "square.grid.2x2")
                            .tag(AppViewStyle.grid)
                    case .list:
                        Image(systemName: "list.bullet")
                            .tag(AppViewStyle.list)
                    }
                }
            }
            .pickerStyle(.palette)
        }
        .sheet(isPresented: $isNewAppSheetPresent) {
            NewAppSheetView()
        }
        .sheet(isPresented: $context.isEditAppPresent) {
            { () -> AnyView in
                guard let app = context.editApp,
                      let controller = DataController.shared,
                      let entity = app.entity(for: controller.context) else {
                    context.present(error: .other(nil))
                    context.isEditAppPresent = false
                    return AnyView(EmptyView())
                }
                let appBinding = Binding(get: { app }, set: { newApp in
                    entity.name = newApp.name
                    entity.path = newApp.winePath.path
                    entity.arguments = newApp.arguments
                    entity.icon = newApp.icon?.tiffRepresentation
                    entity.isHudEnabled = newApp.isHudEnabled
                    entity.isEsyncEnabled = newApp.isEsyncEnabled
                    context.throwing {
                        try controller.save()
                    }
                    context.objectWillChange.send()
                })
                return AnyView(EditAppSheetView(app: appBinding))
            }()
        }
        .alert(isPresented: $context.isErrorPresent, error: context.error) {
            Button("OK", role: .cancel) {}
        }
    }
}

#if DEBUG
#Preview {
    ContentView()
        .environmentObject(Context())
        .frame(width: 700, height: 500)
}
#endif
