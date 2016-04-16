//
//  Definitions.swift
//  Truffaut
//
//  Created by Yan Li on 4/15/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//


// MARK: - Storyboard

struct Storyboard {
  
  struct Names {
    static let main = "Main"
  }
  
  struct Identifiers {
    static let mainWindowController = "MainWindowController"
    static let slidesWindowController = "SlideWindowController"
  }
  
}

protocol StoryboardInstantiatable {
  associatedtype ControllerType
  static var storyboardName: String { get }
  static var storyboardIdentifier: String { get }
  static func loadFromStoryboard() -> ControllerType
}

import AppKit

extension StoryboardInstantiatable {
  
  static var storyboardName: String {
    return Storyboard.Names.main
  }
  
  static var storyboardIdentifier: String {
    return "\(Self.self)"
  }
  
  static func loadFromStoryboard() -> ControllerType {
    let controller = NSStoryboard(name: storyboardName, bundle: nil).instantiateControllerWithIdentifier(storyboardIdentifier) as! ControllerType
    return controller
  }
  
}
