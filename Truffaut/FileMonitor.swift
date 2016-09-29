//
//  FileMonitor.swift
//  Truffaut
//
//  Created by Yan Li on 4/17/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Foundation

class FileMonitor {
  
  typealias EventHandler = () -> Void
  
  let fileURL: NSURL
  let eventHandler: EventHandler

  init(fileURL: NSURL, eventHandler: @escaping EventHandler) {
    self.fileURL = fileURL
    self.eventHandler = eventHandler
    
    // FIXME: Unimplemented
  }
  
  deinit {
    // FIXME: Unimplemented
  }
}
