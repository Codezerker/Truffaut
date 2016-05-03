//
//  RemoteProtocol.swift
//  Truffaut
//
//  Created by Yan Li on 5/3/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Foundation

struct RemoteProtocol {
  
  // Type of the remote service
  static let serviceType = "truffaut-remote"
  
  // Service Commands
  enum Command: Int {
    case Next     = 0xAD1 // Next slide, meaning: A.D., Anno Domini
    case Previous = 0xBC1 // Previous slide, meaning: B.C., Before Christ
    
    // Generate the NSData representation of the rawValue
    func dataRepresentation() -> NSData {
      var intValue = rawValue
      return NSData(bytes: &intValue, length: sizeof(Int.self))
    }
    
    // Initialize a Command with a NSData representation
    init?(data: NSData) {
      var intValue: Int = 0
      data.getBytes(&intValue, length: sizeof(Int.self))
      
      switch intValue {
      case Next.rawValue:
        self = .Next
      case Previous.rawValue:
        self = .Previous
      default:
        return nil
      }
    }
  }
  
}

