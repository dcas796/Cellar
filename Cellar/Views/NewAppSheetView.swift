//
//  NewAppSheetView.swift
//  Cellar
//
//  Created by Dani on 6/10/23.
//

import SwiftUI

struct NewAppSheetView: View {
    @EnvironmentObject var context: Context
    @Environment(\.dismiss) var dismiss: DismissAction
    
    @State var name: String = ""
    @State var path: String = "C:\\"
    @State var icon: NSImage?
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
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
        let app = WineApp(name: name,
                          winePath: path,
                          arguments: [],
                          icon: icon)
        context.insert(app: app)
        dismiss()
    }
}

#if DEBUG
#Preview {
    NewAppSheetView()
        .environmentObject(Context())
}
#endif
