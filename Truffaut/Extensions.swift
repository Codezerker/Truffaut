//
//  Catagories.swift
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import AppKit

extension NSView {
    
    var fullEdgeLayoutConstrains: [NSLayoutConstraint] {
        let views = ["view" : self]
        let visualFormatStrings = [
            "V:|-0-[view]-0-|",
            "H:|-0-[view]-0-|",
            ]
        
        var results = [NSLayoutConstraint]()
        for visualFormatString in visualFormatStrings {
            let constraints = NSLayoutConstraint.constraints(
                withVisualFormat: visualFormatString,
                options: [],
                metrics: nil,
                views: views)
            results += constraints
        }
        
        return results
    }    
}
