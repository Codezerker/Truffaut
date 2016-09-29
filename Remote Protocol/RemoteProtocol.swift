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
  enum Command: UInt8 {
    case Next     = 0x01 // Next slide
    case Previous = 0x10 // Previous slide
    
    // Generate the NSData representation of the rawValue
    func dataRepresentation() -> Data {
      return Data(bytes: [rawValue])
    }
    
    // Initialize a Command with a NSData representation
    init?(data: Data) {
      var intValue: UInt8 = 0
      data.copyBytes(to: &intValue, count: MemoryLayout<Int>.size)
      
      switch intValue {
      case Command.Next.rawValue:
        self = .Next
      case Command.Previous.rawValue:
        self = .Previous
      default:
        return nil
      }
    }
  }
  
}

