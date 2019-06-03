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
    
    private var preferenceWindowController: PreferenceWindowController?
    
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

fileprivate extension AppDelegate {
    
    func openDocumentIfNeeded() {
        NSDocumentController.shared.openDocument(nil)
    }
}

fileprivate extension AppDelegate {
    
    @IBAction func showPreferenceWindow(_ sender: Any?) {
        preferenceWindowController = PreferenceWindowController.loadFromStoryboard()
        preferenceWindowController?.window?.makeKeyAndOrderFront(sender)
    }
}
