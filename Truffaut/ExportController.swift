//
//  ExportController.swift
//  Truffaut
//
//  Created by Yan Li on 23/07/2016.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Foundation

final class ExportController {
  
  private struct Constants {
    
    static let serviceName = "com.codezerker.DocumentExporter"
  }
  
  private var connection: NSXPCConnection

  static let `default` = ExportController()

  init() {
    connection = NSXPCConnection(serviceName: Constants.serviceName)
    connection.remoteObjectInterface = NSXPCInterface(withProtocol: DocumentExporterProtocol.self)
    connection.resume()
  }
  
  deinit {
    connection.invalidate()
  }
  
  func testConnection() {
    let remoteProxy = connection.remoteObjectProxy as! DocumentExporterProtocol
    remoteProxy.upperCaseString("Hello World!") {
      print($0)
    }
  }
}
