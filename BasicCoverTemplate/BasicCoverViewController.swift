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
  @IBOutlet weak var subtitleLabel: NSTextField!
  
  private var titleString = ""
  private var subtitleString: String?
  
  func setContents(title title: String, subtitle: String?) {
    titleString = title
    subtitleString = subtitle
  }
    
  override func viewWillAppear() {
    super.viewWillAppear()
    
    titleLabel.stringValue = titleString
    
    if let subtitleString = subtitleString {
      subtitleLabel.stringValue = subtitleString
    }
  }
  
}
