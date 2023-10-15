//
//  Context.swift
//  Cellar
//
//  Created by Dani on 3/10/23.
//

import Foundation
import Combine

final class Context: ObservableObject {
    @Published var environment: WineEnvironment = WineEnvironment()
    private var environmentCancellable: AnyCancellable?
    private var settingsCancellable: AnyCancellable?
    private var dataControllerCancellable: AnyCancellable?
    
    @Published var isErrorPresent: Bool = false
    var error: CellarError?
    
    @Published var isEditAppPresent: Bool = false
    var editApp: WineApp?
    
    private let wineAppEntityrequest = {
        let request = WineAppEntity.fetchRequest()
//        request.sortDescriptors = [
//            NSSortDescriptor(keyPath: \WineAppEntity.name, ascending: true)
//        ]
        return request
    }()
    
    var apps: Array<WineApp> {
        do {
            return try DataController.shared?.context
                .fetch(wineAppEntityrequest)
                .compactMap(WineApp.from(entity:)) ?? []
        } catch {
            present(error: .failureWhileFetchingApps)
            return []
        }
    }
    
    var initializingApps: [WineApp] {
        Array(environment.initializingApps)
    }
    
    var runningApps: [WineApp] {
        environment.runningProcesses.map { $0.app }
    }
    
    init() {
        environmentCancellable = environment.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.objectWillChange.send()
            }
        }
        settingsCancellable = Settings.shared.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.objectWillChange.send()
            }
        }
        dataControllerCancellable = DataController.publisher.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.objectWillChange.send()
            }
        }
    }
    
    func present(error: CellarError) {
        DispatchQueue.main.async {
            self.error = error
            self.isErrorPresent = true
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func showEditView(app: WineApp) {
        DispatchQueue.main.async {
            self.editApp = app
            self.isEditAppPresent = true
        }
    }
    
    func insert(app: WineApp) {
        guard let controller = DataController.shared else {
            return
        }
        app.createEntity(for: controller.context)
        do {
            try controller.context.save()
            self.objectWillChange.send()
        } catch {
            present(error: .failureWhileSavingApps)
        }
    }
    
    func remove(app: WineApp) {
        guard let controller = DataController.shared else {
            return
        }
        guard let entity = app.entity(for: controller.context) else {
            return
        }
        controller.context.delete(entity)
        do {
            try controller.context.save()
            self.objectWillChange.send()
        } catch {
            present(error: .failureWhileSavingApps)
        }
    }
    
    func run(app: WineApp) {
        dispatchAsync {
            try await self.environment.start(app: app)
            await MainActor.run {
                self.objectWillChange.send()
            }
        }
    }
    
    func stop(app: WineApp) {
        dispatchAsync {
            try await self.environment.stop(app: app)
            await MainActor.run {
                self.objectWillChange.send()
            }
        }
    }

    func throwing<T>(_ code: () throws -> T) -> T? {
        do {
            return try code()
        } catch is CellarError {
            if let error {
                present(error: error)
            } else {
                present(error: .other(nil))
            }
        } catch {
            present(error: .other(error))
        }
        return nil
    }
    
    func dispatchAsync(_ code: @escaping () async throws -> Void) {
        Task {
            do {
                try await code()
            } catch let error as CellarError {
                present(error: error)
            } catch {
                present(error: .other(error))
            }
        }
    }
}
