//
//  BasicPageViewController.swift
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class BasicPageViewController: NSViewController {
  
  @IBOutlet weak var titleLabel: NSTextField!
  @IBOutlet var contentTextView: NSTextView!
  
  private var titleString = ""
  private var contentString = ""
  
  func setContents(title title: String, contents: [String]?) {
    titleString = title
    contentString = contents?.reduce("") { result, element in
      result?.stringByAppendingString("・ " + element + "\n\n")
    } ?? ""
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    
    titleLabel.stringValue = titleString
    contentTextView.string = contentString
  }
  
}
