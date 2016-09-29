//
//  FileMonitor.swift
//  Truffaut
//
//  Created by Yan Li on 4/17/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import CoreServices.FSEvents

class FileMonitor {
  
  typealias EventHandler = () -> Void
  
  let fileURL: NSURL
  let eventHandler: EventHandler

  private var eventStream: FSEventStreamRef?

  init(fileURL: NSURL, eventHandler: @escaping EventHandler) {
    self.fileURL = fileURL
    self.eventHandler = eventHandler
    
    createEventStream()
  }
  
  deinit {
    destroyEventStream()
  }
  
  private func createEventStream() {
    var context = FSEventStreamContext(
      version: 0,
      info: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
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
        guard let info = info else {
          return
        }
        let this = Unmanaged<FileMonitor>.fromOpaque(info).takeUnretainedValue()
        this.eventHandler()
      },
      &context,
      pathsToWatch as CFArray,
      UInt64(kFSEventStreamEventIdSinceNow),
      0,
      UInt32(flags))
    
    guard let eventStream = eventStream else {
      return
    }
    
    FSEventStreamScheduleWithRunLoop(
      eventStream,
      CFRunLoopGetCurrent(),
      CFRunLoopMode.defaultMode as! CFString)
    
    FSEventStreamStart(eventStream)
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
