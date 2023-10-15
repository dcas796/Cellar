//
//  WinePath.swift
//  Cellar
//
//  Created by Dani on 6/10/23.
//

import Foundation

struct WinePath: Hashable, Equatable {
    var absoluteURL: URL
    var driveLetter: Character
    var path: String {
        "\(driveLetter):\(absoluteURL.path(percentEncoded: false).replacing("/", with: "\\"))"
    }
    
    init?(path: String) {
        var path = path
        guard path.count > 2 else {
            return nil
        }
        let driveLetter = path.removeFirst()
        guard path.removeFirst() == ":",
              path.first == "\\" else {
            return nil
        }
        let absoluteURL = URL(filePath: path.replacing("\\", with: "/"))
        self.absoluteURL = absoluteURL.standardizedFileURL
        self.driveLetter = driveLetter
    }
    
    init(url: URL, driveLetter: Character = "C") {
        self.absoluteURL = url
        self.driveLetter = driveLetter
    }
}

extension WinePath: CustomStringConvertible {
    var description: String {
        path
    }
}

extension WinePath: Codable {
    enum CodingKeys: CodingKey {
        case absoluteURL
        case driveLetter
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.absoluteURL = try container.decode(URL.self, forKey: .absoluteURL)
        guard let driveLetter = try container.decode(String.self, forKey: .driveLetter).first else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.driveLetter], debugDescription: "driveLetter must be one character long"))
        }
        self.driveLetter = driveLetter
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(absoluteURL, forKey: .absoluteURL)
        try container.encode(String(driveLetter), forKey: .driveLetter)
    }
}
