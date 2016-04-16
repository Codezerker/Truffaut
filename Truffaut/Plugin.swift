//
//  Plugin.swift
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Foundation

struct Plugin {
  
  static var pluginSearchURL: NSURL? {
    guard let URL = try? NSFileManager.defaultManager().URLForDirectory(
      .ApplicationSupportDirectory,
      inDomain: .UserDomainMask,
      appropriateForURL: nil,
      create: false) else {
        return nil
    }
    
    return URL.URLByAppendingPathComponent("Truffaut/Plugins")
  }
  
  static func createPluginDirectoryIfNeeded() {
    guard let pluginSearchURL = pluginSearchURL else {
      return
    }
    
    _ = try? NSFileManager.defaultManager().createDirectoryAtURL(
      pluginSearchURL,
      withIntermediateDirectories: true,
      attributes: nil);
  }
  
}
