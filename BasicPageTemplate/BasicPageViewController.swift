//
//  BasicPageViewController.swift
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class BasicPageViewController: NSViewController {
  
  @IBOutlet weak var titleLabel: NSTextField?
  @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint?
  @IBOutlet weak var titleContentConstraint: NSLayoutConstraint?
  @IBOutlet var contentTextView: NSTextView?
  
  fileprivate var titleString = ""
  fileprivate var contentString = ""
  
  func setContents(title: String, contents: [String]?) {
    titleString = title
    contentString = contents?.reduce("") { result, element in
      let bulletPointPrefix: String
      let bulletPoint: String
      if element.hasPrefix("  ") {
        bulletPointPrefix = "        ・ "
        let index = element.index(element.startIndex, offsetBy: 2)
        bulletPoint = element.substring(from: index)
      } else {
        bulletPointPrefix = "・ "
        bulletPoint = element
      }
      return result.appending(bulletPointPrefix + bulletPoint + "\n\n")
    }.replacingOccurrences(of: "->", with: " ➞ ") ?? ""
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
  
  private func updateContents() {
    titleLabel?.stringValue = titleString
    contentTextView?.string = contentString
  }
  
}

extension BasicPageViewController {
  
  private struct DynamicFontSize {
    static let defaultWidth: CGFloat = 800
    static let defaultHeight: CGFloat = 600
    static let defaultTitleFontSize: CGFloat = 48
    static let defaultSpacing: CGFloat = 40
    static let defaultContentFontSize: CGFloat = 22
    static let defaultTitleMargin: CGFloat = 20
    
    static var defaultTitleRatio: CGFloat {
      return defaultTitleFontSize / defaultHeight
    }
    
    static var defaultSpacingRatio: CGFloat {
      return defaultSpacing / defaultHeight;
    }
    
    static var defaultContentRatio: CGFloat {
      return defaultContentFontSize / defaultHeight
    }
    
    static func titleFontSizeWithBounds(viewBounds: CGRect) -> CGFloat {
      return viewBounds.height * defaultTitleRatio
    }
    
    static func spacingWithBounds(viewBounds: CGRect) -> CGFloat {
      return viewBounds.height * defaultSpacingRatio
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
    
    let font = NSFont.systemFont(ofSize: DynamicFontSize.titleFontSizeWithBounds(viewBounds: view.bounds), weight: NSFontWeightThin)
    titleLabel?.font = font
    titleLabelHeightConstraint?.constant = titleString.layoutHeightWithFont(font: font, width: DynamicFontSize.layoutWidthWithBounds(viewBounds: view.bounds))
    titleLabel?.needsLayout = true
    titleContentConstraint?.constant = DynamicFontSize.spacingWithBounds(viewBounds: view.bounds)
    
    contentTextView?.font = NSFont.systemFont(ofSize: DynamicFontSize.contentFontSizeWithBounds(viewBounds: view.bounds), weight: NSFontWeightLight)
    contentTextView?.needsLayout = true
  }
  
}

extension String {
  
  func layoutHeightWithFont(font: NSFont?, width: CGFloat) -> CGFloat {
    guard let font = font else {
      return 0
    }
    
    let textStorage = NSTextStorage(string: self)
    let textContainer = NSTextContainer(containerSize: NSSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    let layoutManager = NSLayoutManager()
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)
    textStorage.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: self.utf16.count))
    textContainer.lineFragmentPadding = 0
    layoutManager.glyphRange(for: textContainer)
    
    return layoutManager.usedRect(for: textContainer).height
  }
  
}
