//
//  ArgumentsView.swift
//  Cellar
//
//  Created by Dani on 6/6/24.
//

import SwiftUI

struct ArgumentsView: View {
    @Binding var args: [String]
    
    @State var isAddingArgument: Bool = false
    @State var newArgumentText: String = ""
    
    var body: some View {
        Text("Arguments")
//        WrappingHStack {
//            ForEach(Array(zip(args.indices, args)), id: \.0) { i, arg in
//                self.item {
//                    Text(arg)
//                    Button {
//                            self.args.remove(at: i)
//                    } label: {
//                        Label("Remove", systemImage: "xmark")
//                            .labelStyle(.iconOnly)
//                    }
//                    .buttonStyle(.borderless)
//                }
//            }
//            self.item {
//                if isAddingArgument {
//                    TextField("Argument", text: $newArgumentText)
//                        .onSubmit {
//                            self.isAddingArgument = false
//                            if !newArgumentText.isEmpty {
//                                self.args.append(newArgumentText)
//                                newArgumentText = ""
//                            }
//                        }
//                } else {
//                    Text("Add argument")
//                        .bold()
//                }
//                Button {
//                    if isAddingArgument {
//                        self.isAddingArgument = false
//                        if !newArgumentText.isEmpty {
//                            self.args.append(newArgumentText)
//                            newArgumentText = ""
//                        }
//                    } else {
//                        self.isAddingArgument = true
//                    }
//                } label: {
//                    Label("Add", systemImage: "plus")
//                        .labelStyle(.iconOnly)
//                }
//                .buttonStyle(.borderless)
//            }
//        }
    }
    
    func item(@ViewBuilder content: () -> some View) -> some View {
        HStack(spacing: 8) {
            content()
        }
        .padding(10)
        .background(Color.accentColor.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    @Previewable @State var args = ["/c", "/k", "/dddd", "/akakakaka"]
    return ArgumentsView(args: $args)
        .frame(width: 300)
}
