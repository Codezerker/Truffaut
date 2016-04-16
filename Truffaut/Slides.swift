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
    static let bulletPoints = "bullet_points"
  }
  
  struct Page {
    let typeIdentifier: String
    let title: String
    let bulletPoints: [String]?
  }
  
  var pages: [Page]
  
  typealias PageJSON = [String : AnyObject]
  
  init(json: [PageJSON]) throws {
    guard json.count > 0 else {
      throw Document.Error.InvalidData
    }
    
    pages = try json.map { pageJSON -> Page in
      guard let typeIdentifier = pageJSON[JSONKeys.typeIdentifier] as? String,
            let title = pageJSON[JSONKeys.title] as? String else {
        throw Document.Error.InvalidData
      }
      
      let bulletPoints = pageJSON[JSONKeys.bulletPoints] as? [String]
      
      return Page(typeIdentifier: typeIdentifier, title: title, bulletPoints: bulletPoints)
    }
  }
  
}
