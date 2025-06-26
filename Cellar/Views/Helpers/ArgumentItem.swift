//
//  ArgumentItem.swift
//  Cellar
//
//  Created by Dani on 7/6/24.
//

import SwiftUI

struct ArgumentItem: View {
    var id: Int
    var text: String
    var deleteHandler: (Int, String) -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Text(text)
            Button {
                deleteHandler(id, text)
            } label: {
                Label("Delete", systemImage: "xmark")
                    .labelStyle(.iconOnly)
            }
            .buttonStyle(.borderless)
        }
        .padding(10)
        .background(Color.accentColor.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ArgumentItem(id: 0, text: "/c", deleteHandler: {_,_ in})
}
