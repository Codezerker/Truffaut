//
//  PreferenceViewController.swift
//  Truffaut
//
//  Created by Yan Li on 29/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Cocoa

class PreferenceViewController: NSViewController {

    @IBOutlet private weak var swiftcPathTextField: NSTextField!
    @IBOutlet private weak var activeSwiftcPathLabel: NSTextField!
    @IBOutlet private weak var saveSwiftcPathButton: NSButton!
    
    @IBOutlet private weak var rubyPathTextField: NSTextField!
    @IBOutlet private weak var activeRubyPathLabel: NSTextField!
    @IBOutlet private weak var saveRubyPathButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        activeSwiftcPathLabel.stringValue = Shell.Environment.swiftc
        activeRubyPathLabel.stringValue = Shell.Environment.ruby

        if let customSwiftcPath = UserPreference.customSwiftcPath {
            swiftcPathTextField.stringValue = customSwiftcPath
        }
        if let customRubyPath = UserPreference.customRubyPath {
            rubyPathTextField.stringValue = customRubyPath
        }
    }
    
    @IBAction private func saveCustomSwiftcPath(_ sender: Any?) {
        UserPreference.customSwiftcPath = swiftcPathTextField.stringValue
        updateViews()
    }
    
    @IBAction private func saveCustomRubyPath(_ sender: Any?) {
        UserPreference.customRubyPath = rubyPathTextField.stringValue
        updateViews()
    }
}
