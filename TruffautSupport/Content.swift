//
//  Content.swift
//  Truffaut
//
//  Created by Yan Li on 4/3/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

public enum Content {
    
    public enum FileType: String, Codable {
        case swift
        case shell
    }
    
    case title(String)
    case text(String)
    case image(String)
    case sourceCode(FileType, String)
    
    indirect case indent([Content])
}

extension Content: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case title
        case image
        case text
        
        case sourceCode
        case fileType

        case indent
    }
    
    public enum ContentError: Error {
        case malformedContent
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let title = try? values.decode(String.self, forKey: .title) {
            self = .title(title)
        } else if let imageFilePath = try? values.decode(String.self, forKey: .image) {
            self = .image(imageFilePath)
        } else if let text = try? values.decode(String.self, forKey: .text) {
            self = .text(text)
        } else if let sourceCode = try? values.decode(String.self, forKey: .sourceCode),
                  let fileType = try? values.decode(FileType.self, forKey: .fileType) {
            self = .sourceCode(fileType, sourceCode)
        } else {
            throw ContentError.malformedContent
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .title(let title):
            try container.encode(title, forKey: .title)
        case .image(let imageFilePath):
            try container.encode(imageFilePath, forKey: .image)
        case .text(let text):
            try container.encode(text, forKey: .text)
        case .sourceCode(let fileType, let sourceCode):
            try container.encode(fileType, forKey: .fileType)
            try container.encode(sourceCode, forKey: .sourceCode)
        default:
            throw ContentError.malformedContent
        }
    }
}
