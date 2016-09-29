//
//  Document.swift
//  Truffaut
//
//  Created by Yan Li on 4/14/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

protocol DocumentDataParsing {
  func parse(data: Data) -> [Slides.PageJSON]?
}

class Document: NSDocument {
  
  struct Notifications {
    static let update = "update"
  }
  
  enum ParsingError: Error {
    case InvalidData
  }
  
  var fileNameWithoutExtension: String? {
    return fileURL?.deletingPathExtension().lastPathComponent
  }
  var slides: Slides?
  fileprivate var fileMonitor: FileMonitor?
  
  deinit {
    removeFileMonitor()
  }
  
  override class func autosavesInPlace() -> Bool {
    return true
  }

  override func makeWindowControllers() {
    let windowController = MainWindowController.loadFromStoryboard()
    addWindowController(windowController)
    
    addFileMonitor()
  }
  
  override func data(ofType typeName: String) throws -> Data {
    throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
  }
  
  override func read(from data: Data, ofType typeName: String) throws {
    guard let documentURL = fileURL else {
      return
    }
    
    if let slidesJSON = JSONParser().parse(data: data) {
      slides = try Slides(json: slidesJSON, documentURL: documentURL as NSURL)
    } else if let slidesJSON = SwiftParser().parse(data: data) {
      slides = try Slides(json: slidesJSON, documentURL: documentURL as NSURL)
    } else {
      throw ParsingError.InvalidData
    }
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notifications.update), object: self)
  }
}

fileprivate extension Document {
  
  fileprivate func addFileMonitor() {
    guard let fileURL = fileURL else {
      return
    }
    
    fileMonitor = FileMonitor(fileURL: fileURL as NSURL) { [weak self] in
      guard let fileURL = self?.fileURL,
            let fileType = self?.fileType else {
          return
      }
      _ = try? self?.revert(toContentsOf: fileURL, ofType: fileType)
    }
  }
  
  fileprivate func removeFileMonitor() {
    fileMonitor = nil
  }
  
}
