//
//  NSWindow+Style.swift
//  Truffaut
//
//  Created by Yan Li on 29/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import AppKit

extension NSWindow {
    
    func applyTransparentTitlebarStyle() {
        styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        isMovable = true
        isMovableByWindowBackground = true
    }
}
