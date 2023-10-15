//
//  WineApp.swift
//  Cellar
//
//  Created by Dani on 6/10/23.
//

import Cocoa

struct WineApp: Identifiable {
    var id: UUID
    var name: String
    var winePath: WinePath
    var arguments: [String]
    var icon: NSImage?
    var isHudEnabled: Bool
    var isEsyncEnabled: Bool
    
    private init(id: UUID, name: String, winePath: WinePath, arguments: [String], icon: NSImage?, isHudEnabled: Bool? = nil, isEsyncEnabled: Bool? = nil) {
        self.id = id
        self.name = name
        self.winePath = winePath
        self.arguments = arguments
        self.icon = icon
        self.isHudEnabled = isHudEnabled ?? false
        self.isEsyncEnabled = isEsyncEnabled ?? true
    }
    
    init(name: String, winePath: WinePath, arguments: [String], icon: NSImage? = nil, isHudEnabled: Bool? = nil, isEsyncEnabled: Bool? = nil) {
        self.init(id: UUID(), name: name, winePath: winePath, arguments: arguments, icon: icon)
    }
    
    func entity(for context: NSManagedObjectContext) -> WineAppEntity? {
        let request = WineAppEntity.fetchRequest()
        let id = Optional(self.id)
        request.predicate = NSPredicate(#Predicate<WineAppEntity> { entity in
            entity.id == id
        })
        return try? context.fetch(request).first
    }
    
    @discardableResult
    func createEntity(for context: NSManagedObjectContext) -> WineAppEntity {
        let entity = WineAppEntity(context: context)
        entity.id = self.id
        entity.name = self.name
        entity.path = self.winePath.path
        entity.arguments = self.arguments
        entity.icon = self.icon?.tiffRepresentation
        entity.isHudEnabled = self.isHudEnabled
        entity.isEsyncEnabled = self.isEsyncEnabled
        return entity
    }
}

extension WineApp {
    static let `default`: WineApp = WineApp(name: "Wine App",
                                            winePath: WinePath(path: "C:\\Program Files (x86)\\Steam\\steam.exe")!,
                                            arguments: [])
    
    static func from(entity: WineAppEntity) -> WineApp? {
        guard let path = WinePath(path: entity.path!) else {
            return nil
        }
        var icon: NSImage?
        if let iconData = entity.icon {
            icon = NSImage(data: iconData)
        }
        return WineApp(id: entity.id!,
                       name: entity.name!,
                       winePath: path,
                       arguments: entity.arguments!,
                       icon: icon,
                       isHudEnabled: entity.isHudEnabled,
                       isEsyncEnabled: entity.isEsyncEnabled)
    }
}

extension WineApp: Equatable {
    static func == (lhs: WineApp, rhs: WineApp) -> Bool {
        lhs.id == rhs.id
    }
}

extension WineApp: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension WineApp: CustomStringConvertible {
    var description: String {
        "WineApp(id: \(id.uuidString), name: \"\(name)\", winePath: \"\(winePath.path)\", arguments: \(arguments), icon: \(icon == nil ? "nil" : "NSImage(size: \(icon!.size))"))"
    }
}
