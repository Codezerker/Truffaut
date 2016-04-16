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
    return "basic_page"
  }
  
  func createPageViewControllerWithPageTitle(title: String, bulletPoints: [String]?) -> NSViewController {
    let viewController = BasicPageViewController(
      nibName: BasicPageViewController().className,
      bundle: NSBundle(forClass: BasicPageViewController.classForCoder()))!
    
    viewController.setContents(title: title, contents: bulletPoints)
    
    return viewController
  }
  
}