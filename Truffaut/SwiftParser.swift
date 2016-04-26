//
//  SwiftParser.swift
//  Truffaut
//
//  Created by Yan Li on 4/22/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa
import SourceKittenFramework

struct SwiftParser: DocumentDataParsing {
  
  private struct Keys {
    static let substructure = "key.substructure"
    static let kind         = "key.kind"
    static let name         = "key.name"
    static let elements     = "key.elements"
    static let location     = "key.offset"
    static let length       = "key.length"
    static let bodyLocation = "key.bodyoffset"
    static let bodyLength   = "key.bodylength"
  }
  
  private struct Kinds {
    static let functionCall      = "source.lang.swift.expr.call"
    static let functionParameter = "source.lang.swift.decl.var.parameter"
    static let array             = "source.lang.swift.expr.array"
    static let element           = "source.lang.swift.structure.elem.expr"
  }
  
  private struct Names {
    static let slides       = "Slides"
    static let pages        = "pages"
    static let title        = "title"
    static let bulletPoints = "bulletPoints"
  }
  
  func parse(data: NSData) -> [Slides.PageJSON]? {
    guard let contentString = String(data: data, encoding: NSUTF8StringEncoding) else {
      return nil
    }
    
    let file = File(contents: contentString)
    let structure = Structure(file: file).dictionary
    
    guard let rootExpressions = structure[Keys.substructure] as? [SourceKitRepresentable] where rootExpressions.count == 2,
          let slideInitializeToken = rootExpressions.last as? [String : SourceKitRepresentable],
          let initializeTokenKind = slideInitializeToken[Keys.kind] as? String where initializeTokenKind == Kinds.functionCall,
          let initializeTokenName = slideInitializeToken[Keys.name] as? String where initializeTokenName == Names.slides else {
      return nil
    }
    
    guard let initializeParameterExpressions = slideInitializeToken[Keys.substructure] as? [SourceKitRepresentable] where initializeParameterExpressions.count == 1,
          let parameterToken = initializeParameterExpressions.first as? [String : SourceKitRepresentable],
          let parameterTokenKind = parameterToken[Keys.kind] as? String where parameterTokenKind == Kinds.functionParameter,
          let parameterTokenName = parameterToken[Keys.name] as? String where parameterTokenName == Names.pages else {
      return nil
    }
    
    guard let pagesArrayExpressions = parameterToken[Keys.substructure] as? [SourceKitRepresentable] where pagesArrayExpressions.count == 1,
          let arrayToken = pagesArrayExpressions.first as? [String : SourceKitRepresentable],
          let arrayTokenKind = arrayToken[Keys.kind] as? String where arrayTokenKind == Kinds.array else {
      return nil
    }
    
    guard let arrayElementExpressions = arrayToken[Keys.substructure] as? [SourceKitRepresentable] else {
      return nil
    }
    
    var results: [Slides.PageJSON] = []
    for expression in arrayElementExpressions {
      guard let token = expression as? [String : SourceKitRepresentable],
            let json = parseElementToken(token, contentString: contentString) else {
        continue
      }
      
      results.append(json)
    }
    
    return results
  }

}

private extension SwiftParser {
  
  func parseElementToken(token: [String : SourceKitRepresentable], contentString: String) -> Slides.PageJSON? {
    guard let kind = token[Keys.kind] as? String where kind == Kinds.functionCall,
          let name = token[Keys.name] as? String else {
      return nil
    }
    
    guard let subexpressions = token[Keys.substructure] as? [SourceKitRepresentable] where subexpressions.count == 2,
          let titleToken = subexpressions.first as? [String : SourceKitRepresentable],
          let title = parseElementTitle(titleToken, contentString: contentString) else {
      return nil
    }
    
    let bulletPoints = parseElementBulletPoints(subexpressions.last as? [String : SourceKitRepresentable], contentString: contentString)
    
    return [
      Slides.JSONKeys.typeIdentifier : name,
      Slides.JSONKeys.title : title,
      Slides.JSONKeys.bulletPoints : bulletPoints,
    ]
  }

  func parseElementTitle(token: [String : SourceKitRepresentable], contentString: String) -> String? {
    guard let name = token[Keys.name] as? String where name == Names.title,
          let kind = token[Keys.kind] as? String where kind == Kinds.functionParameter,
          let location = token[Keys.bodyLocation] as? Int64,
          let length = token[Keys.bodyLength] as? Int64 else {
      return nil
    }
    
    let bodyRange = NSRange(location: Int(location), length: Int(length))
    return contentString.extractTokenValueAtRange(bodyRange)
  }
  
  func parseElementBulletPoints(token: [String : SourceKitRepresentable]?, contentString: String) -> [String] {
    guard let token = token,
          let name = token[Keys.name] as? String where name == Names.bulletPoints,
          let kind = token[Keys.kind] as? String where kind == Kinds.functionParameter,
          let subExpressions = token[Keys.substructure] as? [SourceKitRepresentable] where subExpressions.count == 1,
          let bulletPointsArrayToken = subExpressions.first else {
      return []
    }
    
    return parseBulletPoint(bulletPointsArrayToken, contentString: contentString)
  }
  
  func parseBulletPoint(token: SourceKitRepresentable, contentString: String) -> [String] {
    guard let token = token as? [String : SourceKitRepresentable],
          let kind = token[Keys.kind] as? String where kind == Kinds.array,
          let elements = token[Keys.elements] as? [SourceKitRepresentable] else {
      return []
    }
    
    var results = [String]()
    for element in elements {
      guard let token = element as? [String : SourceKitRepresentable],
            let kind = token[Keys.kind] as? String where kind == Kinds.element,
            let location = token[Keys.location] as? Int64,
            let length = token[Keys.length] as? Int64 else {
        return []
      }
      
      let range = NSRange(location: Int(location), length: Int(length))
      results.append(contentString.extractTokenValueAtRange(range))
    }
    
    return results
  }
  
}

private extension String {
  
  func extractTokenValueAtRange(range: NSRange) -> String {
    // FIXME: Find a more generic way to remove '"' and '"' characters
    guard let result = (self as NSString).substringWithByteRange(start: range.location + 1, length: range.length - 2) else {
      return ""
    }

    print("Extract token with range: \(range) -> \(result)")
    
    return result
  }
  
}
