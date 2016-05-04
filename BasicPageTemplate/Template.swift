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
    return "Page"
  }
  
  func createPageViewController() -> NSViewController {
    return BasicPageViewController(
      nibName: BasicPageViewController().className,
      bundle: NSBundle(forClass: BasicPageViewController.classForCoder()))!
  }
  
  func setPageTitleForViewController(viewController: NSViewController, withTitle title: String, bulletPoints: [String]?) {
    guard let viewController = viewController as? BasicPageViewController else {
      return
    }
    
    viewController.setContents(title: title, contents: bulletPoints)
  }
  
}