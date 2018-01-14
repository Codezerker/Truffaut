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
        case plainText	
        case swift
        case shell
        case javaScript
        case c
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
        
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let title = try values.decodeIfPresent(String.self, forKey: .title) {
            self = .title(title)
        } else if let imageFilePath = try values.decodeIfPresent(String.self, forKey: .image) {
            self = .image(imageFilePath)
        } else if let text = try values.decodeIfPresent(String.self, forKey: .text) {
            self = .text(text)
        } else if let sourceCode = try values.decodeIfPresent(String.self, forKey: .sourceCode),
                  let fileType = try values.decodeIfPresent(FileType.self, forKey: .fileType) {
            self = .sourceCode(fileType, sourceCode)
        } else if let contents = try values.decodeIfPresent([Content].self, forKey: .indent) {
            self = .indent(contents)
        } else {
            let context = DecodingError.Context(codingPath: values.codingPath,
                                                debugDescription: "Unexpected content")
            throw DecodingError.dataCorrupted(context)
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
        case .indent(let contents):
            try container.encode(contents, forKey: .indent)
        }
    }
}
