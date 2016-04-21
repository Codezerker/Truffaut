//
//  BasicCoverViewController.swift
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class BasicCoverViewController: NSViewController {
  
  @IBOutlet weak var titleLabel: NSTextField!
  private var titleString = ""
    
  func setContents(title: String) {
    titleString = title
  }
    
  override func viewWillAppear() {
    super.viewWillAppear()
    
    titleLabel.stringValue = titleString
  }
  
}
