//
//  AppGridItem.swift
//  Cellar
//
//  Created by Dani on 12/10/23.
//

import SwiftUI

struct AppGridItem: View {
    @EnvironmentObject var context: Context
    var app: WineApp
    
    static let cornerRadius = CGSize(width: 20, height: 20)
    static let size = CGSize(width: 4 * 40, height: 3 * 40)
    static let maximumSize = CGSize(width: 1.5 * size.width, height: size.height)
    
    var icon: Image {
        if let icon = app.icon {
            Image(nsImage: icon)
        } else {
            Image(systemName: "macwindow")
        }
    }
    
    var isInitializing: Bool {
        context.initializingApps.contains(app)
    }
    
    var isRunning: Bool {
        context.runningApps.contains(app)
    }
    
    var fillColor: Color {
        if isInitializing {
            Color.yellow.opacity(0.4)
        } else {
            isRunning ? Color.accentColor.opacity(0.4) : Color.secondary.opacity(0.2)
        }
    }
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerSize: Self.cornerRadius)
                .stroke(isFocused ? Color.accentColor : Color.clear, lineWidth: 2)
                .fill(fillColor)
                
            VStack(alignment: .leading) {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                Spacer()
                Text(app.name)
                    .font(.headline)
                    .lineLimit(2)
            }
            .padding()
            .foregroundStyle(.primary)
            
            HStack {
                Spacer()
                Button {
                    guard !isInitializing else { return }
                    if isRunning {
                        stopApp()
                    } else {
                        runApp()
                    }
                } label: {
                    Circle()
                        .fill(Color.primary.opacity(0.2))
                        .frame(width: 35)
                        .overlay {
                            if isInitializing {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .controlSize(.small)
                            } else {
                                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                    .imageScale(.large)
                            }
                        }
                }
                .buttonStyle(.borderless)
                .if(isFocused) { button in
                    button
                        .keyboardShortcut(.defaultAction)
                }
            }
            .padding()
        }
        .frame(height: Self.size.height)
        .frame(minWidth: Self.size.height, maxWidth: Self.maximumSize.width)
        .focusable()
        .focusEffectDisabled()
        .focused($isFocused)
        .contextMenu {
            if isInitializing || isRunning {
                Button("Stop") {
                    stopApp()
                }
                .disabled(isInitializing)
            } else {
                Button("Run") {
                    runApp()
                }
            }
            Button("Edit") {
                context.showEditView(app: app)
            }
            Button("Delete") {
                context.remove(app: app)
            }
        }
    }
    
    func runApp() {
        context.run(app: app)
    }
    
    func stopApp() {
        context.stop(app: app)
    }
}

#Preview {
    AppGridItem(app: .default)
        .environmentObject(Context())
        .padding()
}
