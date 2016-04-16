//
//  Plugin.swift
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Foundation

class Plugin {
  
  static let sharedPlugin = Plugin()
  
  var templates = [String : TFSlidesTemplate]()
  
  func loadPlugIns() {
    if let builtInPlugInURL = NSBundle.mainBundle().builtInPlugInsURL {
      loadPluginFromURL(builtInPlugInURL)
    }
    
    createPlugInDirectoryInApplicationSupportIfNeeded()
    if let externalPlugInURL = plugInSearchURL {
      loadPluginFromURL(externalPlugInURL)
    }
  }
  
}

extension Plugin {
  
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
  
  private func loadPluginFromURL(URL: NSURL) {
    let templateMap = TFPlugInLoader.loadSlidesTempatesWithSearchURL(URL)
    templateMap.forEach { key, value in
      self.templates[key] = value
    }
  }
  
}
