//
//  BasicImageViewController.swift
//  Truffaut
//
//  Created by Yan Li on 6/5/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class BasicImageViewController: NSViewController {

  @IBOutlet weak var imageView: NSImageView?
  @IBOutlet weak var captionLabel: NSTextField?
  
  private var image: NSImage?
  private var caption: String?
  
  func setImage(image: NSImage?, caption: String?) {
    self.image = image
    self.caption = caption
    
    updateContents()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    updateContents()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    updateContents()
  }
  
  func updateContents() {
    imageView?.image = image
    captionLabel?.stringValue = caption ?? ""
  }
  
}
