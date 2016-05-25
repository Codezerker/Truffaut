//
//  BasicCoverViewController.swift
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class BasicCoverViewController: NSViewController {
  
  @IBOutlet weak var titleLabel: NSTextField?
  @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint?
  @IBOutlet weak var subtitleLabel: NSTextField?
  
  private var titleString = ""
  private var subtitleString: String?
  
  func setContents(title title: String, subtitle: String?) {
    titleString = title
    subtitleString = subtitle
    updateContents()
  }
    
  override func viewWillAppear() {
    super.viewWillAppear()
    updateContents()
  }
  
  private func updateContents() {
    titleLabel?.stringValue = titleString
    subtitleLabel?.stringValue = subtitleString ?? ""
  }
  
}

extension BasicCoverViewController {
  
  private struct DynamicFontSize {
    static let defaultWidth: CGFloat = 800
    static let defaultHeight: CGFloat = 600
    static let defaultTitleFontSize: CGFloat = 52
    static let defaultContentFontSize: CGFloat = 20
    static let defaultTitleMargin: CGFloat = 20
    
    static var defaultTitleRatio: CGFloat {
      return defaultTitleFontSize / defaultHeight
    }
    
    static var defaultContentRatio: CGFloat {
      return defaultContentFontSize / defaultHeight
    }
    
    static func titleFontSizeWithBounds(viewBounds: CGRect) -> CGFloat {
      return viewBounds.height * defaultTitleRatio
    }
    
    static func contentFontSizeWithBounds(viewBounds: CGRect) -> CGFloat {
      return viewBounds.height * defaultContentRatio
    }
    
    static func layoutWidthWithBounds(viewBounds: CGRect) -> CGFloat {
      return viewBounds.width - 2 * defaultTitleMargin
    }
  }
  
  override func viewWillLayout() {
    super.viewWillLayout()
    
    let font = NSFont.systemFontOfSize(DynamicFontSize.titleFontSizeWithBounds(view.bounds), weight: NSFontWeightThin)
    titleLabel?.font = font
    titleHeightConstraint?.constant = titleString.layoutHeightWithFont(font, width: DynamicFontSize.layoutWidthWithBounds(view.bounds))
    titleLabel?.needsLayout = true
    
    subtitleLabel?.font = NSFont.systemFontOfSize(DynamicFontSize.contentFontSizeWithBounds(view.bounds), weight: NSFontWeightThin)
    subtitleLabel?.needsLayout = true
  }
  
}

extension String {
  
  func layoutHeightWithFont(font: NSFont?, width: CGFloat) -> CGFloat {
    guard let font = font else {
      return 0
    }
    
    let textStorage = NSTextStorage(string: self)
    let textContainer = NSTextContainer(containerSize: NSSize(width: width, height: CGFloat.max))
    let layoutManager = NSLayoutManager()
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)
    textStorage.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: self.utf16.count))
    textContainer.lineFragmentPadding = 0
    layoutManager.glyphRangeForTextContainer(textContainer)
    
    return layoutManager.usedRectForTextContainer(textContainer).height
  }
  
}
