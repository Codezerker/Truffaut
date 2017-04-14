//
//  PagePresentable.swift
//  Truffaut
//
//  Created by Yan Li on 4/14/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import AppKit
import TruffautSupport

protocol PagePresentable: class {
    
    static func presentationViewController(for page: Page) -> NSViewController?
}
