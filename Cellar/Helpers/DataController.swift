//
//  DataController.swift
//  Cellar
//
//  Created by Dani on 8/10/23.
//

import Foundation
import CoreData

struct DataController {
    static private(set) var shared: DataController? = {
        DataController.initializeShared()
        return nil
    }()
    static let publisher: Publisher = Publisher()
    
    let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    init() async throws {
        self.container = NSPersistentContainer(name: "Cellar")
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            container.loadPersistentStores { description, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
    
    func save() throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw CellarError.failureWhileSavingApps
            }
        }
    }
    
    func destroy() throws {
        for store in container.persistentStoreCoordinator.persistentStores {
            try container.persistentStoreCoordinator.destroyPersistentStore(
                at: store.url!,
                ofType: store.type,
                options: nil
            )
        }
        DataController.shared = nil
        DataController.initializeShared()
    }
}

extension DataController {
    private static func initializeShared() {
        Task {
            do {
                DataController.shared = try await DataController()
                DataController.publisher.objectWillChange.send()
            } catch {
                print("[DataController] Could not load persistent stores from 'Cellar'")
                await MainActor.run {
                    CellarApp.showModal(title: "There was an error while initializing the app.",
                                        description: error.localizedDescription) {
                        fatalError("Could not load CoreData models. Shutting down...")
                    }
                }
            }
        }
    }
}

extension DataController {
    final class Publisher: ObservableObject {
        init() {}
    }
}
