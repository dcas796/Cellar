//
//  DetailAppView.swift
//  Cellar
//
//  Created by Dani on 5/11/23.
//

import SwiftUI

struct DetailAppView: View {
    @EnvironmentObject var context: Context
    
    @Binding var app: WineApp
    
    var icon: Image {
        app.icon ?? Image(systemName: "macwindow")
    }
    
    var spacer: some View {
        Spacer()
            .frame(height: 20)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 75)
                    
                spacer
                
                HStack(spacing: 20) {
                    TextField("Name", text: $app.name)
                        .font(.title)
                        .bold()
                        .textFieldStyle(.plain)
                        .onSubmit {
                            saveApp()
                        }
                    
                    Button("Edit") {
                        context.showEditView(app: app)
                    }
                }
                
                Text(app.winePath.path)
                    .textSelection(.enabled)
                    .font(.subheadline)
                    .fontDesign(.monospaced)
                    .foregroundStyle(Color.secondary)
                
                spacer
                    
                VStack(alignment: .leading) {
                    Text("Arguments")
                        .bold()
                    
                    ArgumentsView(args: $app.arguments)
                }
                
                spacer
                
                Toggle("Show Metal HUD while gaming", isOn: $app.isHudEnabled)
                Toggle("Enable Wine Esync", isOn: $app.isEsyncEnabled)
                
                spacer
                
                HStack {
                    Button("Run") {
                        context.run(app: app)
                    }
                    .controlSize(.large)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .onChange(of: app.isHudEnabled) {
                saveApp()
            }
            .onChange(of: app.isEsyncEnabled) {
                saveApp()
            }
        }
        .frame(minWidth: 100, maxWidth: .infinity)
    }
    
    func saveApp() {
        guard let controller = DataController.shared,
              let entity = app.updateEntity(for: controller.context) else {
            context.present(error: .failureWhileSavingApps)
            return
        }
        
        context.throwing {
            try controller.save()
        }
        
        context.objectWillChange.send()
    }
}

#Preview {
    DetailAppView(app: .constant(.default))
        .environmentObject(Context())
        .frame(width: 400)
}
