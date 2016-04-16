//
//  ViewController.swift
//  Truffaut
//
//  Created by Yan Li on 4/14/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
  
  @IBOutlet weak var pathControl: NSPathControl!
  
  weak var windowController: MainWindowController?
  
  lazy var slidesWindowController: SlidesWindowController = {
    return SlidesWindowController.loadFromStoryboard()
  }()
  
  override func viewWillAppear() {
    super.viewWillAppear()
    
    pathControl.URL = windowController?.document?.fileURL
  }
  
  @IBAction func showSlides(sender: AnyObject?) {
    slidesWindowController.window?.makeKeyAndOrderFront(nil)
  }
  
}
