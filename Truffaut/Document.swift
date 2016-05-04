//
//  Document.swift
//  Truffaut
//
//  Created by Yan Li on 4/14/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

protocol DocumentDataParsing {
  func parse(data: NSData) -> [Slides.PageJSON]?
}

class Document: NSDocument {
  
  struct Notifications {
    static let update = "update"
  }
  
  enum Error: ErrorType {
    case InvalidData
  }
  
  var slides: Slides?
  
  override class func autosavesInPlace() -> Bool {
    return true
  }

  override func makeWindowControllers() {
    let windowController = MainWindowController.loadFromStoryboard()
    addWindowController(windowController)
  }

  override func dataOfType(typeName: String) throws -> NSData {
    throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
  }

  override func readFromData(data: NSData, ofType typeName: String) throws {
    if let slidesJSON = JSONParser().parse(data) {
      slides = try Slides(json: slidesJSON)
    } else if let slidesJSON = SwiftParser().parse(data) {
      slides = try Slides(json: slidesJSON)
    } else {
      throw Error.InvalidData
    }
    
    NSNotificationCenter.defaultCenter().postNotificationName(Notifications.update, object: self)
  }

}
