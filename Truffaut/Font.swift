//
//  Font.swift
//  Truffaut
//
//  Created by Yan Li on 17/08/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import AppKit

struct DynamicLayout {
    
    private static let defaultScreenSize = NSSize(width: 800, height: 600)
    static var currentScreenSize = DynamicLayout.defaultScreenSize
    
    static func sizeFittingCurrentScreenSize(originalSize: CGFloat) -> CGFloat {
        return min(originalSize / DynamicLayout.defaultScreenSize.width * DynamicLayout.currentScreenSize.width,
                   originalSize / DynamicLayout.defaultScreenSize.height * DynamicLayout.currentScreenSize.height)
    }
}

struct Font {

    struct Cover {
        
        static var title: NSFont {
            return NSFont.boldSystemFont(ofSize: DynamicLayout.sizeFittingCurrentScreenSize(originalSize: 42))
        }
        
        static var subtitle: NSFont {
            return NSFont.systemFont(ofSize: DynamicLayout.sizeFittingCurrentScreenSize(originalSize: 24))
        }
    }
    
    struct Page {
        
        static var title: NSFont {
            return NSFont.boldSystemFont(ofSize: DynamicLayout.sizeFittingCurrentScreenSize(originalSize: 38))
        }
        
        static var text: NSFont {
            return NSFont.systemFont(ofSize: DynamicLayout.sizeFittingCurrentScreenSize(originalSize: 24))
        }
        
        static var source: NSFont {
            guard let sfMono = NSFont(name: "SF Mono", size: DynamicLayout.sizeFittingCurrentScreenSize(originalSize: 18)) else {
                return text
            }
            return sfMono
        }
    }
}

struct TextColor {

    struct Display {
        static let title = NSColor.white
        static let subtitle = NSColor.white
        static let text = NSColor.white
        static let source = NSColor.white
    }
    
    struct Export {
        static let title = NSColor.black
        static let subtitle = NSColor.black
        static let text = NSColor.black
        static let source = NSColor.black
    }
}
