//
//  JSONParser.swift
//  Truffaut
//
//  Created by Yan Li on 4/22/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

struct JSONParser: DocumentDataParsing {

  func parse(data: NSData) -> [Slides.PageJSON]? {
    let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
    return json as? [Slides.PageJSON]
  }
  
}
