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
    
    @Binding var app: WineApp
    
    @State var name: String
    @State var path: String
    @State var icon: NSImage?
    
    init(app: Binding<WineApp>) {
        self._app = app
        self._name = State(initialValue: app.wrappedValue.name)
        self._path = State(initialValue: app.wrappedValue.winePath.path)
        self._icon = State(initialValue: app.wrappedValue.icon)
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            AppEditForm(name: $name, path: $path, icon: $icon)
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
        }
        .formStyle(.grouped)
        .fixedSize(horizontal: false, vertical: true)
        .frame(minWidth: 400, maxWidth: 800)
    }
    
    func saveApp() {
        guard let path = WinePath(path: path) else {
            context.present(error: .invalidPath)
            return
        }
        self.app.name = name
        self.app.winePath = path
        self.app.arguments = []
        self.app.icon = icon
        
        dismiss()
    }
}

#Preview {
    EditAppSheetView(app: .constant(.default))
        .environmentObject(Context())
}
