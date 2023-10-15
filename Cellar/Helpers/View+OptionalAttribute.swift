//
//  View+OptionalAttribute.swift
//  Cellar
//
//  Created by Dani on 13/10/23.
//

import SwiftUI

extension View {
    func `if`(_ condition: Bool, @ViewBuilder _ content: (Self) -> some View) -> some View {
        condition ? AnyView(content(self)) : AnyView(self)
    }
}
