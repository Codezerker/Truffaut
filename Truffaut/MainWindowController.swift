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
    
    window?.styleMask |= NSFullSizeContentViewWindowMask
    window?.titlebarAppearsTransparent = true
    window?.movable = true
  }

}

extension MainWindowController: StoryboardInstantiatable {
  
  typealias ControllerType = MainWindowController
  
}
