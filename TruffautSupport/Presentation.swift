//
//  Presentation.swift
//  Truffaut
//
//  Created by Yan Li on 4/3/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

public struct Presentation: Codable {
    
    public let title: String
    public let authors: [String]
    public let pages: [Page]
    
    public init(title: String = "", authors: [String] = [], pages: [Page]) {
        self.title = title
        self.authors = authors
        self.pages = pages
        
        // dump self as a JSON String to STDOUT
        dump()
    }
}

private extension Presentation {
    
    private func dump() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(self),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        print(jsonString)
    }
}
