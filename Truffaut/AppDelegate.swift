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
