//
//  ViewController.swift
//  Truffaut
//
//  Created by Yan Li on 4/14/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

  lazy var slidesWindowController: SlidesWindowController = {
    return SlidesWindowController.loadFromStoryboard()
  }()
  
  @IBAction func showSlides(sender: AnyObject?) {
    slidesWindowController.window?.makeKeyAndOrderFront(nil)
  }
  
}
