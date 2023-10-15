//
//  RunView.swift
//  Cellar
//
//  Created by Dani on 15/10/23.
//

import SwiftUI

struct RunView: View {
    @Environment(\.dismiss) var dismiss: DismissAction
    
    @EnvironmentObject var context: Context
    
    @State var command: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Run programs")
                .font(.title)
                .bold()
            
            TextField("Program", text: $command)
                .onSubmit(run)
            
            Button("Run") {
                run()
            }
            .keyboardShortcut(.defaultAction)
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(minWidth: 200, idealWidth: 400, maxWidth: .infinity)
    }
    
    func run() {
        if !command.isEmpty {
            context.run(command: command)
        }
        dismiss()
    }
}

#Preview {
    RunView()
        .environmentObject(Context())
}
