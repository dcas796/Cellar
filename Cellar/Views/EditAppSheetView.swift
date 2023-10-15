//
//  EditAppSheetView.swift
//  Cellar
//
//  Created by Dani on 7/10/23.
//

import SwiftUI

struct EditAppSheetView: View {
    @EnvironmentObject var context: Context
    
    @Environment(\.dismiss) var dismiss: DismissAction
    
    @State var path: String = ""
    
    var body: some View {
        VStack(alignment: .trailing) {
            if let app = Binding($context.editApp) {
                AppEditForm(name: app.name,
                            path: $path,
                            icon: app.icon)
                    .onSubmit(saveApp)
                
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    Button("Save") {
                        saveApp()
                    }
                    .keyboardShortcut(.defaultAction)
                }
                .padding([.top], 0)
                .padding([.bottom, .trailing], 20)
            } else {
                Text("There was error while loading the Edit sheet.")
                
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(minWidth: 400, maxWidth: 800)
        .onAppear {
            if let app = context.editApp {
                self.path = app.winePath.path
            }
        }
    }
    
    func saveApp() {
        guard let app = context.editApp else {
            context.present(error: .other(nil))
            return
        }
        
        guard WinePath(path: path) != nil else {
            context.present(error: .invalidPath)
            return
        }
        
        guard let controller = DataController.shared,
              let entity = app.updateEntity(for: controller.context) else {
            context.present(error: .failureWhileSavingApps)
            dismiss()
            return
        }
        
        entity.path = path
        
        context.throwing {
            try controller.save()
        }
        
        context.objectWillChange.send()
        
        dismiss()
    }
}

#Preview {
    EditAppSheetView()
        .environmentObject(Context())
}
