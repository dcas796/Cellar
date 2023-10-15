//
//  CellarApp.swift
//  Cellar
//
//  Created by Dani on 1/10/23.
//

import SwiftUI

@main
struct CellarApp: App {
    @Environment(\.scenePhase) var scenePhase: ScenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Context())
        }
        .onChange(of: scenePhase) {
            (try? DataController.shared?.save()) ?? {
                print("[CellarApp] Could not auto-save.")
            }()
        }
        
        SwiftUI.Settings {
            SettingsView()
        }
    }
}

extension CellarApp {
    static func showModal(title: String, description: String? = nil, showsCancelButton: Bool = false, blocking: Bool = false, callback: (() -> Void)?) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = description ?? ""
        if showsCancelButton {
            alert.addButton(withTitle: "Cancel")
        }
        let button = alert.addButton(withTitle: "OK")
        if let callback {
            let action = _ButtonAction(runLoop: blocking ? RunLoop.current : nil, callback: callback)
            button.keyEquivalent = "\r"
            button.target = action
            // FIXME: Doesn't do anything when "OK" button pressed.
            button.action = #selector(_ButtonAction.stopRunLoop)
        }
        alert.runModal()
        if blocking {
            RunLoop.current.run()
        }
    }
}

fileprivate final class _ButtonAction: NSObject {
    var runLoop: RunLoop?
    var callback: () -> Void
    
    init(runLoop: RunLoop?, callback: @escaping () -> Void) {
        self.runLoop = runLoop
        self.callback = callback
    }
    
    @objc func stopRunLoop() {
        callback()
        if let runLoop {
            CFRunLoopStop(runLoop.getCFRunLoop())
        }
    }
}
