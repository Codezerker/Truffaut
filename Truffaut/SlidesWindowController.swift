//
//  SlidesWindowController.swift
//  Truffaut
//
//  Created by Yan Li on 4/15/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class SlidesWindowController: NSWindowController {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    window?.styleMask |= NSFullSizeContentViewWindowMask
    window?.titlebarAppearsTransparent = true
    window?.titleVisibility = .Hidden
    window?.movable = true
  }
  
}

extension SlidesWindowController: StoryboardInstantiatable {
  
  typealias ControllerType = SlidesWindowController
  
}
