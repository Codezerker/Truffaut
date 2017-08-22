//
//  PageViewController.swift
//  Truffaut
//
//  Created by Yan Li on 17/08/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import AppKit
import TruffautSupport

class PageViewController: NSViewController {

    @IBOutlet private weak var visualEffectView: NSVisualEffectView!
    private weak var contentStackView: NSStackView?
    
    let page: Page
    let imageBaseURL: URL
    let isExporting: Bool
    
    init(page: Page, imageBaseURL: URL, isExporting: Bool = false) {
        self.page = page
        self.imageBaseURL = imageBaseURL
        self.isExporting = isExporting
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        DynamicLayout.currentScreenSize = view.bounds.size
        setUpViews()
    }
}

fileprivate extension PageViewController {
    
    private struct LayoutConstants {
        
        static var pageMargin: CGFloat {
            return DynamicLayout.sizeFittingCurrentScreenSize(originalSize: 42)
        }
        
        static var spacing: CGFloat {
            return DynamicLayout.sizeFittingCurrentScreenSize(originalSize: 16)
        }
        
        static var indentOffset: CGFloat {
            return DynamicLayout.sizeFittingCurrentScreenSize(originalSize: 32)
        }
    }
    
    private func setUpViews() {
        self.contentStackView?.removeFromSuperview()
        
        let contentStackView = NSStackView(views: [])
        contentStackView.orientation = .vertical
        contentStackView.spacing = LayoutConstants.spacing
        contentStackView.edgeInsets = NSEdgeInsets(top: LayoutConstants.pageMargin,
                                                   left: LayoutConstants.pageMargin,
                                                   bottom: LayoutConstants.pageMargin,
                                                   right: LayoutConstants.pageMargin)
        visualEffectView.addSubview(contentStackView)
        self.contentStackView = contentStackView
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            contentStackView.leftAnchor.constraint(equalTo: visualEffectView.leftAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor),
            contentStackView.rightAnchor.constraint(equalTo: visualEffectView.rightAnchor),
            ])
        
        if page.contents != nil {
            layoutPage()
        } else {
            layoutPageAsCover()
        }
    }
    
    private func layoutPageAsCover() {
        guard let contentStackView = contentStackView else {
            return
        }
        
        contentStackView.alignment = .centerX
        contentStackView.distribution = .gravityAreas
        
        let titleLabel = NSTextField(wrappingLabelWithString: page.title ?? "")
        titleLabel.font = Font.Cover.title
        titleLabel.textColor = isExporting ? TextColor.Export.title : TextColor.Display.title
        contentStackView.addView(titleLabel, in: .center)
        
        let subtitleLabel = NSTextField(wrappingLabelWithString: page.subtitle ?? "")
        subtitleLabel.font = Font.Cover.subtitle
        subtitleLabel.textColor = isExporting ? TextColor.Export.title : TextColor.Display.subtitle
        contentStackView.addView(subtitleLabel, in: .center)
    }
    
    private func layoutPage() {
        guard let contents = page.contents,
              let contentStackView = contentStackView else {
            return
        }
        
        let pageGravity: NSStackView.Gravity
        if let title = page.title {
            contentStackView.alignment = .leading
            contentStackView.distribution = .gravityAreas

            pageGravity = .top
            
            let titleLabel = NSTextField(wrappingLabelWithString: page.title ?? "")
            titleLabel.font = Font.Page.title
            titleLabel.textColor = isExporting ? TextColor.Export.title : TextColor.Display.title
            contentStackView.addView(titleLabel, in: pageGravity)
        } else {
            contentStackView.alignment = .centerX
            contentStackView.distribution = .gravityAreas
            
            pageGravity = .center
        }
        
        // FIXME: layout subtitle
        
        func addContent(content: Content, to stackView: NSStackView, isLast: Bool) {
            switch content {
            case .indent(let nestedContents):
                let indentStackView = NSStackView(views: [])
                indentStackView.orientation = .vertical
                indentStackView.alignment = .leading
                indentStackView.distribution = .gravityAreas
                indentStackView.edgeInsets = NSEdgeInsets(top: 0, left: LayoutConstants.indentOffset, bottom: 0, right: 0)
                for nestedContent in nestedContents {
                    addContent(content: nestedContent, to: indentStackView, isLast: false)
                }
                stackView.addView(indentStackView, in: pageGravity)
            case .text(let text):
                let displayText = text.replacingOccurrences(of: "->", with: " ➞ ")
                let label = NSTextField(wrappingLabelWithString: displayText)
                label.font = Font.Page.text
                label.textColor = isExporting ? TextColor.Export.text : TextColor.Display.text
                stackView.addView(label, in: pageGravity)
            case .sourceCode(let source):
                let label = NSTextField(wrappingLabelWithString: source)
                label.font = Font.Page.source
                label.textColor = isExporting ? TextColor.Export.source : TextColor.Display.source
                stackView.addView(label, in: pageGravity)
            case .image(let relativePath):
                let imageURL = imageBaseURL.appendingPathComponent(relativePath, isDirectory: false)
                guard let image = NSImage(contentsOf: imageURL) else {
                    break
                }
                let imageView = NSImageView(image: image)
                imageView.imageScaling = .scaleProportionallyUpOrDown
                stackView.addView(imageView, in: pageGravity)
            default:
                break
            }
            
            if isLast {
                // workaround: insert a vertically growable dummy view
                // this will make sure there is no ambiguity in vertical layout
                let bottomView = NSView()
                bottomView.setContentHuggingPriority(.defaultLow, for: .vertical)
                stackView.addView(bottomView, in: .bottom)
            }
        }
        
        for (index, content) in contents.enumerated() {
            addContent(content: content, to: contentStackView, isLast: index + 1 == contents.count)
        }
    }
}
