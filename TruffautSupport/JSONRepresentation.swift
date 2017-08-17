//
//  JSONRepresentation.swift
//  Truffaut
//
//  Created by Yan Li on 4/3/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String : Any]

public protocol JSONRepresentation {
    
    var jsonRepresentation: JSONDictionary { get }
    init?(jsonDictionary: JSONDictionary)
}

extension Presentation: JSONRepresentation {
    
    fileprivate struct JSONKeys {
        static let title = "title"
        static let authors = "authors"
        static let pages = "pages"
    }
    
    public var jsonRepresentation: JSONDictionary {
        return [
            JSONKeys.title : title,
            JSONKeys.authors : authors,
            JSONKeys.pages : pages.map { $0.jsonRepresentation },
        ]
    }

    public init?(jsonDictionary: JSONDictionary) {
        guard let title = jsonDictionary[JSONKeys.title] as? String,
              let authors = jsonDictionary[JSONKeys.authors] as? [String],
              let pageJSON = jsonDictionary[JSONKeys.pages] as? [JSONDictionary] else {
            return nil
        }
        self.title = title
        self.authors = authors
        self.pages = pageJSON.flatMap { Page(jsonDictionary: $0) }
    }
}

extension Page: JSONRepresentation {
    
    fileprivate struct JSONKeys {
        static let title = "title"
        static let subtitle = "subtitle"
        static let contents = "contents"
    }
    
    public var jsonRepresentation: JSONDictionary {
        var result: JSONDictionary = [:]
        
        if let title = title {
            result[JSONKeys.title] = title
        }
        
        if let subtitle = subtitle {
            result[JSONKeys.subtitle] = subtitle
        }
        
        if let contents = contents {
            result[JSONKeys.contents] = contents.map { $0.jsonRepresentation }
        }
        
        return result
    }
    
    public init?(jsonDictionary: JSONDictionary) {
        title = jsonDictionary[JSONKeys.title] as? String
        subtitle = jsonDictionary[JSONKeys.subtitle] as? String
        
        let contentJSON = jsonDictionary[JSONKeys.contents] as? [JSONDictionary]
        contents = contentJSON?.flatMap { Content(jsonDictionary: $0) }
    }
}

extension Content: JSONRepresentation {
    
    fileprivate struct JSONKeys {
        static let title = "title"
        static let indent = "indent"
        static let sourceCode = "source_code"
        static let image = "image"
        static let text = "text"
    }
    
    public var jsonRepresentation: JSONDictionary {
        switch self {
        case .title(let title):
            return [
                JSONKeys.title : title,
            ]
        case .indent(let contents):
            return [
                JSONKeys.indent : contents.map { $0.jsonRepresentation },
            ]
        case .image(let path):
            return [
                JSONKeys.image : path,
            ]
        case .sourceCode(let path):
            return [
                JSONKeys.sourceCode : path
            ]
        case .text(let value):
            return [
                JSONKeys.text : value,
            ]
        }
    }
    
    public init?(jsonDictionary: JSONDictionary) {
        guard let firstKey = jsonDictionary.keys.first else {
            return nil
        }
        switch firstKey {
        case JSONKeys.title:
            guard let title = jsonDictionary[firstKey] as? String else {
                return nil
            }
            self = .title(title)
        case JSONKeys.indent:
            guard let contentJSON = jsonDictionary[firstKey] as? [JSONDictionary] else {
                return nil
            }
            self = .indent(contentJSON.flatMap { Content(jsonDictionary: $0) })
        case JSONKeys.image:
            guard let imagePath = jsonDictionary[firstKey] as? String else {
                return nil
            }
            self = .image(imagePath)
        case JSONKeys.sourceCode:
            guard let sourceCodePath = jsonDictionary[firstKey] as? String else {
                return nil
            }
            self = .sourceCode(sourceCodePath)
        case JSONKeys.text:
            guard let value = jsonDictionary[firstKey] as? String else {
                return nil
            }
            self = .text(value)
        default:
            return nil
        }
    }
}
