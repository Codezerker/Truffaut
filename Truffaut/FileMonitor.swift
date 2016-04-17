//
//  FileMonitor.swift
//  Truffaut
//
//  Created by Yan Li on 4/17/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import CoreServices

class FileMonitor {
  
  let fileURL: NSURL
  let eventHandler: dispatch_block_t

  private var eventStream: FSEventStreamRef?

  init(fileURL: NSURL, eventHandler: dispatch_block_t) {
    self.fileURL = fileURL
    self.eventHandler = eventHandler
    
    createEventStream()
  }
  
  deinit {
    destroyEventStream()
  }
  
  private func createEventStream() {
    var this = self
    withUnsafeMutablePointer(&this) { pointerToThis in
      var context = FSEventStreamContext(
        version: 0,
        info: pointerToThis,
        retain: nil,
        release: nil,
        copyDescription: nil)

      guard let watchPath = fileURL.path else {
        return
      }
      
      let pathsToWatch = [watchPath]
      let flags = kFSEventStreamCreateFlagUseCFTypes |
                  kFSEventStreamCreateFlagFileEvents |
                  kFSEventStreamCreateFlagNoDefer
      
      eventStream = FSEventStreamCreate(
        kCFAllocatorDefault,
        { _, info, _, _, _, _ in
          let this = unsafeBitCast(info.memory, FileMonitor.self)
          this.eventHandler()
        },
        &context,
        pathsToWatch,
        UInt64(kFSEventStreamEventIdSinceNow),
        0,
        UInt32(flags))
      
      guard let eventStream = eventStream else {
        return
      }
      
      FSEventStreamScheduleWithRunLoop(
        eventStream,
        CFRunLoopGetCurrent(),
        kCFRunLoopDefaultMode)
      
      FSEventStreamStart(eventStream)
    }
  }
  
  private func destroyEventStream() {
    guard let eventStream = eventStream else {
      return
    }
    
    FSEventStreamStop(eventStream)
    FSEventStreamInvalidate(eventStream)
    self.eventStream = nil
  }
  
}
