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
    @IBOutlet fileprivate weak var scrollView: NSScrollView!
    
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
    
    override func viewWillLayout() {
        super.viewWillLayout()
        DynamicLayout.currentScreenSize = view.bounds.size
        setUpViews()
    }
}

fileprivate class FlippedView: NSView {
    
    override var isFlipped: Bool {
        return true
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
        scrollView.documentView = nil
        
        let contentStackView = NSStackView(frame: .zero)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.orientation = .vertical
        contentStackView.spacing = LayoutConstants.spacing
        contentStackView.edgeInsets = NSEdgeInsets(top: LayoutConstants.pageMargin,
                                                   left: LayoutConstants.pageMargin,
                                                   bottom: LayoutConstants.pageMargin,
                                                   right: LayoutConstants.pageMargin)
        
        if page.contents != nil {
            layoutPage(in: contentStackView)
        } else {
            layoutPageAsCover(in: contentStackView)
        }
        
        let documentView = FlippedView(frame: view.bounds)
        documentView.translatesAutoresizingMaskIntoConstraints = false
        documentView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            documentView.widthAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.width),
            documentView.heightAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.height),
            
            contentStackView.topAnchor.constraint(equalTo: documentView.topAnchor),
            contentStackView.leftAnchor.constraint(equalTo: documentView.leftAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: documentView.bottomAnchor),
            contentStackView.rightAnchor.constraint(equalTo: documentView.rightAnchor),
            ])
        
        scrollView.documentView = documentView
    }
    
    private func layoutPageAsCover(in contentStackView: NSStackView) {
        contentStackView.alignment = .centerX
        contentStackView.distribution = .gravityAreas
        
        let titleLabel = NSTextField(wrappingLabelWithString: page.title ?? "")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = Font.Cover.title
        titleLabel.textColor = isExporting ? TextColor.Export.title : TextColor.Display.title
        contentStackView.addView(titleLabel, in: .center)
        
        let subtitleLabel = NSTextField(wrappingLabelWithString: page.subtitle ?? "")
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = Font.Cover.subtitle
        subtitleLabel.textColor = isExporting ? TextColor.Export.title : TextColor.Display.subtitle
        contentStackView.addView(subtitleLabel, in: .center)
    }
    
    private func layoutPage(in contentStackView: NSStackView) {
        guard let contents = page.contents else {
            return
        }
        
        let pageGravity: NSStackView.Gravity
        if let title = page.title {
            contentStackView.alignment = .leading
            contentStackView.distribution = .gravityAreas

            pageGravity = .top
            
            let titleLabel = NSTextField(wrappingLabelWithString: page.title ?? "")
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
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
                indentStackView.translatesAutoresizingMaskIntoConstraints = false
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
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = Font.Page.text
                label.textColor = isExporting ? TextColor.Export.text : TextColor.Display.text
                stackView.addView(label, in: pageGravity)
            case .sourceCode(let fileType, let source):
                let label: NSTextField
                switch fileType {
                case .plainText:
                    label = NSTextField(labelWithString: source)
                default:
                    guard let sourceWithSyntaxHighlighting =
                        SyntaxHighlighter.attributedString(from: source,
                                                           ofType: fileType,
                                                           withFont: Font.Page.source) else {
                        label = NSTextField(labelWithString: source)
                        break
                    }
                    label = NSTextField(labelWithAttributedString: sourceWithSyntaxHighlighting)
                }
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = Font.Page.source
                label.textColor = isExporting ? TextColor.Export.source : TextColor.Display.source
                stackView.addView(label, in: pageGravity)
            case .image(let relativePath):
                let imageURL = imageBaseURL.appendingPathComponent(relativePath, isDirectory: false)
                guard let image = NSImage(contentsOf: imageURL) else {
                    break
                }
                let imageView = NSImageView(image: image)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.imageScaling = .scaleProportionallyUpOrDown
                stackView.addView(imageView, in: pageGravity)
            default:
                break
            }
            
            if isLast {
                // workaround: insert a vertically growable dummy view
                // this will make sure there is no ambiguity in vertical layout
                let bottomView = NSView()
                bottomView.translatesAutoresizingMaskIntoConstraints = false
                bottomView.setContentHuggingPriority(.defaultLow, for: .vertical)
                stackView.addView(bottomView, in: .bottom)
            }
        }
        
        for (index, content) in contents.enumerated() {
            addContent(content: content, to: contentStackView, isLast: index + 1 == contents.count)
        }
    }
}
