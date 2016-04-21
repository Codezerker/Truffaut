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
  
  private var fileMonitor: FileMonitor?
  
  private lazy var slidesWindowController: SlidesWindowController = {
    return SlidesWindowController.loadFromStoryboard()
  }()
  
  override func viewWillAppear() {
    super.viewWillAppear()
    
    if let fileURL = (windowController?.document as? Document)?.fileURL {
      pathControl.URL = fileURL
      createFileMonitor(fileURL)
    }
  }
  
  @IBAction func showSlides(sender: AnyObject?) {
    windowController?.document?.addWindowController(slidesWindowController)
    slidesWindowController.showWindow(nil)
    
    windowController?.window?.orderOut(nil)
  }
  
  private func createFileMonitor(fileURL: NSURL) {
    guard fileMonitor == nil else {
      return
    }
    
    fileMonitor = FileMonitor(fileURL: fileURL) { [weak self] in
      dispatch_async(dispatch_get_main_queue()) {
        self?.handleFileEvent()
      }
    }
  }
  
  private func handleFileEvent() {
    // TODO: Handle Event
    print(#function)
  }
  
}
