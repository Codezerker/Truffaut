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
        
        window?.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        window?.isMovable = true
        window?.isMovableByWindowBackground = true
        
        if let contentViewController = contentViewController as? MainViewController {
            contentViewController.windowController = self
        }
    }
}

extension MainWindowController: StoryboardInstantiatable {
    
    typealias ControllerType = MainWindowController
}
