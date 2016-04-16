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
    return "basic_cover"
  }
  
  func createPageViewControllerWithPageTitle(title: String, bulletPoints: [String]?) -> NSViewController {
    let viewController = BasicCoverViewController(
      nibName: BasicCoverViewController().className,
      bundle: NSBundle(forClass: BasicCoverViewController.classForCoder()))!
    
    viewController.setContents(title)
    
    return viewController
  }
  
}