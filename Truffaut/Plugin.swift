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
    if let builtInPlugInURL = Bundle.main.builtInPlugInsURL {
      loadPlugInFromURL(URL: builtInPlugInURL)
    }
    
    // Create external plugin directory if needed
    createPlugInDirectoryInApplicationSupportIfNeeded()
    
    // Load external plugins
    if let externalPlugInURL = plugInSearchURL {
      loadPlugInFromURL(URL: externalPlugInURL)
    }
  }
  
}

extension PlugIn {
  
  fileprivate var plugInSearchURL: URL? {
    guard let URL = try? FileManager.default.url(
      for: .applicationSupportDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false) else {
        return nil
    }
    
    return URL.appendingPathComponent("Truffaut/PlugIns", isDirectory: true)
  }
  
  fileprivate func createPlugInDirectoryInApplicationSupportIfNeeded() {
    guard let plugInSearchURL = plugInSearchURL else {
      return
    }
    
    _ = try? FileManager.default.createDirectory(
      at: plugInSearchURL,
      withIntermediateDirectories: true,
      attributes: nil);
  }
  
  fileprivate func loadPlugInFromURL(URL: URL) {
    let templateMap = TFPlugInLoader.loadSlidesTempates(withSearch: URL)
    templateMap.forEach { key, value in
      self.templates[key] = value
    }
  }
  
}
