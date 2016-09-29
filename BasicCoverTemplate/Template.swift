//
//  Template.swift
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class Template: NSObject, TFTemplate {
  
  func typeIdentifier() -> String {
    return "Cover"
  }
  
  func createPageViewController() -> NSViewController {
    return BasicCoverViewController(
      nibName: BasicCoverViewController().className,
      bundle: Bundle(for: BasicCoverViewController.classForCoder()))!
  }
  
  func setPageTitleFor(_ viewController: NSViewController, withTitle title: String, bulletPoints: [String]?) {
    guard let viewController = viewController as? BasicCoverViewController else {
      return
    }
    
    viewController.setContents(title: title, subtitle: bulletPoints?.joined(separator: " | "))
  }
}
