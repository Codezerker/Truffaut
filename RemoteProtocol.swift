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
  }
  
}

