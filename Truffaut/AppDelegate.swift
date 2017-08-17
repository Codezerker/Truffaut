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

// MARK: - Defaut Actions

fileprivate extension AppDelegate {
    
    fileprivate func openDocumentIfNeeded() {
        NSDocumentController.shared.openDocument(nil)
    }
}

// MARK: - Fabric

import Fabric
import Crashlytics

fileprivate extension AppDelegate {
    
    fileprivate func setupFabric() {
        UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions" : true])
        Fabric.with([Crashlytics.self])
    }
}
