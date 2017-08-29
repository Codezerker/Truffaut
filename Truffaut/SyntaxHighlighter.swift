//
//  SyntaxHighlighter.swift
//  Truffaut
//
//  Created by Yan Li on 29/08/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import AppKit
import TruffautSupport

struct SyntaxHighlighter {
    
    static func attributedString(from sourceCode: String, ofType type: Content.FileType, withFont font: NSFont) -> NSAttributedString? {
        guard let scriptPath = Bundle.main.path(forResource: "syntax-hl", ofType: "rb") else {
            return nil
        }
        do {
            var output = try Shell.call(command: "/usr/local/bin/ruby", arguments: [
                scriptPath,
                sourceCode,
                type.rawValue,
            ])
            output.removeLast() // remove '\n'
            return attributedString(from: output, font: font)
        } catch {
            return nil
        }
    }
    
    private static func attributedString(from htmlString: String, font: NSFont) -> NSAttributedString? {
        let renderableString = htmlString.replacingOccurrences(of: "\n", with: "<br>")
                                         .replacingOccurrences(of: "    ", with: "&nbsp;&nbsp;&nbsp;&nbsp;")
        guard let htmlData = renderableString.data(using: .utf8),
              let attrString = NSMutableAttributedString(html: htmlData, baseURL: URL(string: "/")!, documentAttributes: nil) else {
            return nil
        }
        let fullStringRange = NSRange(location: 0, length: attrString.length)
        attrString.addAttribute(.font, value: font, range: fullStringRange)
        attrString.enumerateAttribute(.foregroundColor, in: fullStringRange, options: []) { attr, range, _ in
            guard let foregroundColor = attr as? NSColor,
                  foregroundColor.redComponent == 0,
                  foregroundColor.greenComponent == 0,
                  foregroundColor.blueComponent == 0,
                  foregroundColor.alphaComponent == 1 else {
                return
            }
            attrString.addAttribute(.foregroundColor, value: TextColor.Display.source, range: range)
        }
        return attrString
    }
}
