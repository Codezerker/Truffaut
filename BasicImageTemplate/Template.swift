//
//  Template.swift
//  Truffaut
//
//  Created by Yan Li on 6/5/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Foundation

class Template: NSObject, TFTemplate {
  
  func typeIdentifier() -> String {
    return "Image"
  }
  
  func createPageViewController() -> NSViewController {
    return BasicImageViewController(
      nibName: BasicImageViewController().className,
      bundle: NSBundle(forClass: BasicImageViewController.classForCoder()))!
  }
  
  func setPageTitleForViewController(viewController: NSViewController, withTitle title: String, bulletPoints: [String]?) {
    guard let viewController = viewController as? BasicImageViewController else {
      return
    }
    
    let image = NSImage(contentsOfFile: title)
    let caption = bulletPoints?.joinWithSeparator("\n")
    viewController.setImage(image, caption: caption)
  }
  
}
