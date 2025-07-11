//
//  WineEnvironment.swift
//  Cellar
//
//  Created by Dani on 13/10/23.
//

import Foundation

@MainActor
final class WineEnvironment: ObservableObject {
    typealias OSProcess = Foundation.Process
    
    let interpreterPath = WinePath(path: "C:\\Windows\\System32\\cmd.exe")!
    
    @Published var initializingApps: Set<WineApp> = []
    @Published var runningProcesses: Set<Process> = []
    
    var wineExecutable: URL {
        Settings.shared.wineExecutable
    }
    
    var prefix: URL {
        Settings.shared.winePrefix
    }
    
    @discardableResult
    func start(app: WineApp) async throws -> Process {
        defer { initializingApps.remove(app) }
        try checkExecutableExists()
        
        guard !initializingApps.contains(app) && !runningProcesses.contains(where: { $0.app == app }) else {
            throw CellarError.alreadyRunning(app)
        }
        
        print("Starting app: \(app)")
        initializingApps.insert(app)
        
        let process = try await startProcess(app: app, isCommand: false)
        
        initializingApps.remove(app)
        runningProcesses.insert(process)
        
        return process
    }
    
    func stop(app: WineApp, force: Bool = false) async throws {
        guard let process = runningProcesses.first(where: { $0.app == app }) else {
            throw CellarError.noProcessRunning(app)
        }
        
        print("Stopping app: \(app)")
        initializingApps.insert(app)
        
        try await stopProcess(process: process, force: force)
        
        initializingApps.remove(app)
        runningProcesses.remove(process)
    }
    
    @discardableResult
    func run(command: String) async throws -> Process {
        let app = WineApp(name: command,
                          winePath: interpreterPath,
                          arguments: ["/c", command])
        let process = try await startProcess(app: app, isCommand: true)
        runningProcesses.insert(process)
        return process
    }
    
    @discardableResult
    func openWineSettings() async throws -> Process {
        try await run(command: "winecfg")
    }
    
    private func checkExecutableExists() throws {
        guard FileManager.default.fileExists(atPath: wineExecutable.path(percentEncoded: false)) else {
            throw CellarError.wineExecutableNotFound
        }
    }
    
    private func startProcess(app: WineApp, isCommand: Bool) async throws -> Process {
        let osProcess = OSProcess()
        osProcess.executableURL = wineExecutable
        
        var arguments = [app.winePath.path]
        arguments += app.arguments
        osProcess.arguments = arguments
        
        print("arguments:", arguments)
        
        var environment: [String : String] = ["WINEPREFIX" : prefix.path(percentEncoded: false)]
        if app.isHudEnabled {
            environment["MTL_HUD_ENABLED"] = "1"
        }
        if app.isEsyncEnabled {
            environment["WINEESYNC"] = "1"
        }
        osProcess.environment = environment
        
        print("environment:", environment)
        
        osProcess.terminationHandler = handleProcessTermination(_:)
        osProcess.standardOutput = try FileHandle(forWritingTo: URL(filePath: "/dev/null"))
        osProcess.standardError = try FileHandle(forWritingTo: URL(filePath: "/dev/null"))
        
        try osProcess.run()
        
        return Process(app: app,
                       osProcess: osProcess,
                       pid: osProcess.processIdentifier,
                       executableURL: wineExecutable,
                       arguments: arguments,
                       isCommand: isCommand)
    }
    
    private func stopProcess(process: Process, force: Bool) async throws {
        if force {
            kill(process.osProcess.processIdentifier as pid_t, SIGKILL)
        } else {
            process.osProcess.terminate()
        }
    }
    
    nonisolated private func handleProcessTermination(_ osProcess: OSProcess) {
        DispatchQueue.main.async {
            guard let process = self.runningProcesses.first(where: { $0.pid == osProcess.processIdentifier }) else {
                print("[WineEnvironment] Ignoring termination of process with pid \(osProcess.processIdentifier) as it is not registered as running")
                return
            }
            self.runningProcesses.remove(process)
        }
    }
}

extension WineEnvironment {
    struct Process: Equatable, Hashable {
        var app: WineApp
        var osProcess: OSProcess
        var pid: Int32
        var executableURL: URL
        var arguments: [String]
        var isCommand: Bool
    }
}

extension WineEnvironment.Process: Identifiable {
    var id: Int32 { pid }
}
