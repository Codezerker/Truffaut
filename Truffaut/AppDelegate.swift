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

  func applicationDidFinishLaunching(_ notification: Notification) {
    setupFabric()
    PlugIn.sharedPlugIn.loadPlugIns()
    RemoteServer.sharedServer.start()
    openDocumentIfNeeded()
  }
  
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if flag {
      return true
    } else {
      openDocumentIfNeeded()
      return false
    }
  }
  
}

// MARK: - Menu Action

extension AppDelegate {
  
  @IBAction func nextClicked(_ : AnyObject?) {
    MenuActionDispatcher.ActionType.Next.sendNotification()
  }
  
  @IBAction func previousClicked(_ : AnyObject?) {
    MenuActionDispatcher.ActionType.Previous.sendNotification()
  }
  
  @IBAction func exportClicked(_ : AnyObject?) {
    MenuActionDispatcher.ActionType.Export.sendNotification()
  }
  
}


// MARK: - Defaut Actions

fileprivate extension AppDelegate {
  
  fileprivate func openDocumentIfNeeded() {
    NSDocumentController.shared().openDocument(nil)
  }
  
}

// MARK: - Fabric

import Fabric
import Crashlytics

fileprivate extension AppDelegate {
  
  fileprivate func setupFabric() {
    UserDefaults.standard.register(defaults: [
      "NSApplicationCrashOnExceptions" : true
    ])
    Fabric.with([Crashlytics.self])
  }
  
}
