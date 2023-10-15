//
//  Settings.swift
//  Cellar
//
//  Created by Dani on 14/10/23.
//

import SwiftUI

final class Settings: ObservableObject {
    static let shared: Settings = Settings()
    
    // MARK: Wine Settings
    @AppStorage("winePrefix") var winePrefix: URL = URL.homeDirectory.appending(path: "my-game-prefix")
    @AppStorage("wineExecutable") var wineExecutable: URL = URL(filePath: "/usr/local/opt/game-porting-toolkit/bin/wine64")
    
    private init() {}
}
