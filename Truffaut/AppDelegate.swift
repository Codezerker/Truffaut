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
    openDocumentIfNeeded()
  }
  
  func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
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

private extension AppDelegate {
  
  private func openDocumentIfNeeded() {
    NSDocumentController.sharedDocumentController().openDocument(nil)
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
