//
//  AppEditForm.swift
//  Cellar
//
//  Created by Dani on 7/10/23.
//

import SwiftUI

struct AppEditForm: View {
    @Binding var name: String
    @Binding var path: String
    @Binding var icon: NSImage?
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Path of executable", text: $path)
            HStack {
                Text("Icon")
                Spacer()
                IconPicker(icon: $icon)
            }
        }
    }
}

#Preview {
    AppEditForm(name: .constant(""), path: .constant("C:\\"), icon: .constant(nil))
}
