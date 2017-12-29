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
        
        window?.applyTransparentTitlebarStyle()
        
        if let contentViewController = contentViewController as? MainViewController {
            contentViewController.windowController = self
        }
    }
}

extension MainWindowController: StoryboardInstantiatable {
    
    typealias ControllerType = MainWindowController
}
