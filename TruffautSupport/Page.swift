//
//  Page.swift
//  Truffaut
//
//  Created by Yan Li on 4/3/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

public struct Page {
    
    public let title: String?
    public let subtitle: String?
    public let contents: [Content]?
    
    public init(title: String? = nil, subtitle: String? = nil, contents: [Content]? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.contents = contents
    }
}
