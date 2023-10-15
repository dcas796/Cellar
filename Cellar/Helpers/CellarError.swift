//
//  CellarError.swift
//  Cellar
//
//  Created by Dani on 6/10/23.
//

import Foundation

enum CellarError {
    case dataStorageAppsCorrupted
    case failureWhileSavingSettings
    case failureWhileSavingIcon
    case failureWhileSavingApps
    case failureWhileFetchingApps
    case invalidPath
    case alreadyRunning(WineApp)
    case noProcessRunning(WineApp)
    case wineExecutableNotFound
    case other(Error?)
}

extension CellarError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .dataStorageAppsCorrupted:
            return "Cannot retrieve apps from storage as it is corrupted. All apps are going to be going to be deleted."
        case .failureWhileSavingSettings:
            return "Cannot save custom settings. Please try again later."
        case .failureWhileSavingIcon:
            return "Cannot save custom icon. Please try again later."
        case .failureWhileSavingApps:
            return "Cannot save apps. Please try again later."
        case .failureWhileFetchingApps:
            return "Cannot get apps. Please try again later."
        case .invalidPath:
            return "The path specified is invalid."
        case .alreadyRunning(let app):
            return "\(app.name) is already running."
        case .noProcessRunning(let app):
            return "\(app.name) is not currently running."
        case .wineExecutableNotFound:
            return "Cannot run wine as the specified executable does not exist. If not already, install Game Porting Toolkit."
        case .other(let error):
            if let error {
                return error.localizedDescription
            } else {
                return "Unexpected error"
            }
        }
    }
}
