//
//  Content.swift
//  Truffaut
//
//  Created by Yan Li on 4/3/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

public enum Content {
    
    indirect case bulletPoints([Content])
    case text(String)
    case image(URL)
}
