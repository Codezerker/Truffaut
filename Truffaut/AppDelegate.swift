//
//  AppDelegate.swift
//  Truffaut
//
//  Created by Yan Li on 4/14/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

// MARK: - App Delegate

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    setupFabric()
    PlugIn.sharedPlugIn.loadPlugIns()
    RemoteServer.sharedServer.start()
  }
  
}

// MARK: - Menu Action

extension AppDelegate {
  
  @IBAction func menuAction(sender: AnyObject) {
    guard let menuItem = sender as? NSMenuItem else {
      return
    }
    
    MenuActionDispatcher.dispatchAction(menuItem)
  }
  
}

// MARK: - Fabric

import Fabric
import Crashlytics

private extension AppDelegate {
  
  private func setupFabric() {
    NSUserDefaults.standardUserDefaults().registerDefaults([
      "NSApplicationCrashOnExceptions" : true
    ])
    Fabric.with([Crashlytics.self])
  }
  
}
