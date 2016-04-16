//
//  Plugin.swift
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Foundation

class PlugIn {
  
  static let sharedPlugIn = PlugIn()
  
  var templates = [String : TFTemplate]()
  
  func loadPlugIns() {
    // Load built-in plugins
    if let builtInPlugInURL = NSBundle.mainBundle().builtInPlugInsURL {
      loadPlugInFromURL(builtInPlugInURL)
    }
    
    // Create external plugin directory if needed
    createPlugInDirectoryInApplicationSupportIfNeeded()
    
    // Load external plugins
    if let externalPlugInURL = plugInSearchURL {
      loadPlugInFromURL(externalPlugInURL)
    }
  }
  
}

extension PlugIn {
  
  private var plugInSearchURL: NSURL? {
    guard let URL = try? NSFileManager.defaultManager().URLForDirectory(
      .ApplicationSupportDirectory,
      inDomain: .UserDomainMask,
      appropriateForURL: nil,
      create: false) else {
        return nil
    }
    
    return URL.URLByAppendingPathComponent("Truffaut/PlugIns")
  }
  
  private func createPlugInDirectoryInApplicationSupportIfNeeded() {
    guard let plugInSearchURL = plugInSearchURL else {
      return
    }
    
    _ = try? NSFileManager.defaultManager().createDirectoryAtURL(
      plugInSearchURL,
      withIntermediateDirectories: true,
      attributes: nil);
  }
  
  private func loadPlugInFromURL(URL: NSURL) {
    let templateMap = TFPlugInLoader.loadSlidesTempatesWithSearchURL(URL)
    templateMap.forEach { key, value in
      self.templates[key] = value
    }
  }
  
}
