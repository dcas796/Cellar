//
//  CellarTests.swift
//  CellarTests
//
//  Created by Dani on 6/10/23.
//

@testable import Cellar
import XCTest

final class CellarTests: XCTestCase {
    func testWinePathFromPath() throws {
        let path = "C:\\Program Files\\Steam\\steam.exe"
        guard let winePath = WinePath(path: path) else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(path, winePath.path)
    }
    
    func testWinePathFromURL() throws {
        let url = URL(filePath: "/Program Files/Steam/steam.exe")
        let expectedPath = "C:\\Program Files\\Steam\\steam.exe"
        let winePath = WinePath(url: url)
        XCTAssertEqual(expectedPath, winePath.path)
    }
    
    func testWineAppEquality() throws {
        let app1 = WineApp(name: "Steam", winePath: WinePath(path: "C:\\Program Files\\Steam\\steam.exe")!, arguments: [])
        let app2 = WineApp(name: "Steam2", winePath: WinePath(path: "C:\\Program Files\\Steam\\steam.exe")!, arguments: [])
        XCTAssertNotEqual(app1, app2)
        
        let app3 = WineApp(name: "Steam", winePath: WinePath(path: "C:\\Program Files\\Steam\\steam.exe")!, arguments: [])
        XCTAssertEqual(app1, app3)
        let app4 = WineApp(name: "Steam2", winePath: WinePath(path: "C:\\Program Files\\Steam\\steam2.exe")!, arguments: [])
        XCTAssertNotEqual(app3, app4)
    }
    
    func testWineAppSet() throws {
        let app1 = WineApp(name: "Steam", winePath: WinePath(path: "C:\\Program Files\\Steam\\steam.exe")!, arguments: [])
        let app2 = WineApp(name: "Steam2", winePath: WinePath(path: "C:\\Program Files\\Steam\\steam.exe")!, arguments: [])
        let app3 = WineApp(name: "Steam", winePath: WinePath(path: "C:\\Program Files\\Steam\\steam.exe")!, arguments: [])
        var set = Set<WineApp>()
        
        set.insert(app1)
        set.insert(app3)
        set.insert(app2)
        set.remove(app3)
        set.remove(app2)
        
        XCTAssertEqual(set, [])
    }
}
