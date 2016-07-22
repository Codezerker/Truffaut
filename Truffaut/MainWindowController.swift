//
//  MainWindowController.swift
//  Truffaut
//
//  Created by Yan Li on 4/15/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
  override func awakeFromNib() {
    super.awakeFromNib()
    
    window?.styleMask.insert(NSFullSizeContentViewWindowMask)
    window?.titlebarAppearsTransparent = true
    window?.titleVisibility = .Hidden
    window?.movable = true
    window?.movableByWindowBackground = true
    
    if let contentViewController = contentViewController as? MainViewController {
      contentViewController.windowController = self
    }
  }

}

extension MainWindowController: StoryboardInstantiatable {
  
  typealias ControllerType = MainWindowController
  
}
