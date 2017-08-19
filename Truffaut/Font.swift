//
//  Font.swift
//  Truffaut
//
//  Created by Yan Li on 17/08/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import AppKit

struct Font {
    
    struct Cover {
        static let title = NSFont.boldSystemFont(ofSize: 42)
        static let subtitle = NSFont.systemFont(ofSize: 24)
    }
    
    struct Page {
        static let title = NSFont.boldSystemFont(ofSize: 38)
        static let text = NSFont.systemFont(ofSize: 24)
        static let source = NSFont(name: "SF Mono", size: 18)
    }
}

struct TextColor {

    static let title = NSColor.white
    static let subtitle = NSColor.white
    static let text = NSColor.white
    static let source = NSColor.white
}
