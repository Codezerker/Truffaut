//
//  Slides.swift
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

struct Slides {
  
  struct JSONKeys {
    static let title = "title"
    static let bulletPoints = "bullet_points"
  }
  
  struct Page {
    let title: String
    let bulletPoints: [String]
  }
  
  var pages: [Page]
  
  typealias PageJSON = [String : AnyObject]
  
  init(json: [PageJSON]) throws {
    pages = try json.map { pageJSON -> Page in
      guard let title = pageJSON[JSONKeys.title] as? String,
            let bulletPoints = pageJSON[JSONKeys.bulletPoints] as? [String] else {
        throw Document.Error.InvalidData
      }
      return Page(title: title, bulletPoints: bulletPoints)
    }
  }
  
}
