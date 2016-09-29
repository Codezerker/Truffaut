//
//  Slides.swift
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

struct Slides {
  
  struct JSONKeys {
    static let typeIdentifier = "type"
    static let title = "title"
    static let bulletPoints = "bulletPoints"
  }
  
  struct Types {
    static let cover = "Cover"
    static let image = "Image"
    static let page = "Page"
  }
  
  struct Page {
    let typeIdentifier: String
    let title: String
    let bulletPoints: [String]?
    
    init(typeIdentifier: String, title: String, bulletPoints: [String]?, documentURL: NSURL) {
      self.typeIdentifier = typeIdentifier
      self.bulletPoints = bulletPoints
      
      switch typeIdentifier {
      case Types.image:
        let documentRootURL = documentURL.deletingLastPathComponent
        let imageURL = documentRootURL?.appendingPathComponent(title, isDirectory: false)
        self.title = imageURL?.path ?? title
      default:
        self.title = title
      }
    }
  }
  
  var pages: [Page]
  
  typealias PageJSON = [String : Any]
  
  init(json: [PageJSON], documentURL: NSURL) throws {
    guard json.count > 0 else {
      throw Document.ParsingError.InvalidData
    }
    
    pages = try json.map { pageJSON -> Page in
      guard let typeIdentifier = pageJSON[JSONKeys.typeIdentifier] as? String,
            let title = pageJSON[JSONKeys.title] as? String else {
        throw Document.ParsingError.InvalidData
      }
      
      let bulletPoints = pageJSON[JSONKeys.bulletPoints] as? [String]
      
      return Page(
        typeIdentifier: typeIdentifier,
        title: title,
        bulletPoints: bulletPoints,
        documentURL: documentURL
      )
    }
  }
  
}
