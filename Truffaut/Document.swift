//
//  Document.swift
//  Truffaut
//
//  Created by Yan Li on 4/14/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class Document: NSDocument {
  
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
    let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
    
    guard let slidesJSON = json as? [Slides.PageJSON] else {
      throw Error.InvalidData
    }
    
    self.slides = try Slides(json: slidesJSON)
  }

}

